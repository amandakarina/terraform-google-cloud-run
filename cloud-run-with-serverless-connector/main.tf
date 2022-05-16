locals {
  location = "us-central1"
  vpc_name = "shared-vpc-tf"
}

resource "google_project_service" "vpcaccess-api" {
  project = var.serverless_project_id
  service = "vpcaccess.googleapis.com"
}

resource "google_project_service" "cloud-run" {
  project = var.serverless_project_id
  service = "run.googleapis.com"
}

resource "google_project_service" "compute-engine-api-serverless" {
  project = var.serverless_project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "compute-engine-api-vpc" {
  project = var.vpc_project_id
  service = "compute.googleapis.com"
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id      = var.vpc_project_id
  network_name    = local.vpc_name
  routing_mode    = "GLOBAL"
  shared_vpc_host = true
  mtu             = 1460

  subnets = [
    {
      subnet_name   = "sub-${local.vpc_name}"
      subnet_ip     = "10.10.10.0/28"
      subnet_region = local.location
    }
  ]

  depends_on = [
    google_project_service.compute-engine-api-serverless,
    google_project_service.compute-engine-api-vpc,
  ]
}

module "net-shared-vpc-access" {
  source              = "terraform-google-modules/network/google//modules/fabric-net-svpc-access"
  version             = "~> 4.0"
  host_project_id     = var.vpc_project_id
  service_project_num = 1
  service_project_ids = [var.serverless_project_id]
  host_subnets        = ["sub-${local.vpc_name}"]
  host_subnet_regions = [local.location]
  host_subnet_users = {
    "sub-${local.vpc_name}" = "serviceAccount:${var.terraform_service_account}"
  }
  host_service_agent_role = true
  host_service_agent_users = [
    "serviceAccount:${var.terraform_service_account}"
  ]

  depends_on = [
    module.vpc
  ]
}

resource "google_compute_firewall" "serverless-to-vpc-connector" {
  project       = var.vpc_project_id
  name          = "serverless-to-vpc-connector"
  network       = local.vpc_name
  direction     = "INGRESS"
  source_ranges = ["107.178.230.64/26", "35.199.224.0/19"]
  target_tags = ["vpc-connector"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["667"]
  }

  allow {
    protocol = "udp"
    ports    = ["665", "666"]
  }

  depends_on = [
    module.net-shared-vpc-access
  ]
}

resource "google_compute_firewall" "vpc-connector-to-serverless" {
  project       = var.vpc_project_id
  name          = "vpc-connector-to-serverless"
  network       = local.vpc_name
  direction     = "EGRESS"
  source_ranges = ["107.178.230.64/26", "35.199.224.0/19"]
  target_tags = ["vpc-connector"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["667"]
  }

  allow {
    protocol = "udp"
    ports    = ["665", "666"]
  }

  depends_on = [
    module.net-shared-vpc-access
  ]
}

resource "google_compute_firewall" "vpc-connector-health-checks" {
  project       = var.vpc_project_id
  name          = "vpc-connector-health-checks"
  network       = local.vpc_name
  direction     = "INGRESS"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "108.170.220.0/23"]
  target_tags = ["vpc-connector"]

  allow {
    protocol = "tcp"
    ports    = ["667"]
  }

  depends_on = [
    module.net-shared-vpc-access
  ]
}

resource "google_compute_firewall" "vpc-connector-requests" {
  project   = var.vpc_project_id
  name      = "vpc-connector-requests"
  network   = local.vpc_name
  direction = "INGRESS"
  source_tags = ["vpc-connector"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  depends_on = [
    module.net-shared-vpc-access
  ]
}

resource "google_project_iam_member" "gcp_sa_vpcaccess" {
  project = var.vpc_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-${var.serverless_project_number}@gcp-sa-vpcaccess.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cloud_services" {
  project = var.vpc_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${var.serverless_project_number}@cloudservices.gserviceaccount.com"
}

module "serverless-connector" {
  source     = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  project_id = var.serverless_project_id
  vpc_connectors = [{
    name            = "serverless-vpc-connector"
    region          = local.location
    subnet_name     = "sub-${local.vpc_name}"
    host_project_id = var.vpc_project_id
    machine_type    = "e2-micro"
    min_instances   = 2
    max_instances   = 7
    }
  ]
  depends_on = [
    google_project_service.vpcaccess-api,
    google_project_iam_member.gcp_sa_vpcaccess,
    google_project_iam_member.cloud_services
  ]
}

module "cloud_run" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "~> 0.2.0"

  service_name           = "mygcrservice"
  project_id             = var.serverless_project_id
  location               = local.location
  image                  = "us-docker.pkg.dev/cloudrun/container/hello"
  service_account_email  = "${var.serverless_project_number}-compute@developer.gserviceaccount.com"
  template_annotations = {
    "autoscaling.knative.dev/maxScale": 2,
    "autoscaling.knative.dev/minScale": 1,
    "run.googleapis.com/vpc-access-connector" = "serverless-vpc-connector",
    "run.googleapis.com/vpc-access-egress" = "all-traffic"
  }

  depends_on = [
    module.serverless-connector,
    google_project_service.cloud-run
  ]
}