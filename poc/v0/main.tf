/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

 locals {
  serverless_apis = ["vpcaccess.googleapis.com", "compute.googleapis.com", "container.googleapis.com", "run.googleapis.com", "cloudkms.googleapis.com"]
  vpc_apis        = ["vpcaccess.googleapis.com", "container.googleapis.com"]
}

resource "google_project_service" "serverless_project_apis" {
  for_each           = toset(local.serverless_apis)
  project            = var.serverless_project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_project_service" "vpc_project_id_apis" {
  for_each           = toset(local.vpc_apis)
  project            = var.vpc_project_id
  service            = each.value
  disable_on_destroy = false
}

 resource "google_project_service_identity" "serverless_sa" {
  provider = google-beta
  project  = var.serverless_project_id
  service  = "run.googleapis.com"
}

data "google_project" "serverless_project_id" {
    project_id = var.serverless_project_id
}

module "cloud_run" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "~> 0.3.0"

  service_name          = "hello-world-with-apis-test"
  project_id            = var.serverless_project_id
  location              = var.location
  image                 = var.image
  service_account_email = var.cloud_run_sa
  template_annotations = {
    "autoscaling.knative.dev/maxScale" : 2,
    "autoscaling.knative.dev/minScale" : 1,
    "run.googleapis.com/vpc-access-connector" = tolist(module.serverless-connector.connector_ids)[0],
    "run.googleapis.com/vpc-access-egress"    = "all-traffic"
  }

  encryption_key = module.cloud_run_kms.keys["cloud_run"]

  env_vars = [{ name : "PROJECT_ID", value : var.serverless_project_id }]

  depends_on = [
    module.serverless-connector
  ]
}
