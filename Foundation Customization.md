# Instructions to customize Foundation for Serverless deployment

## 0-bootstrap

1. Add `roles/vpcaccess.admin` and `roles/iam.securityAdmin` role in `0-bootstrap/modules/granular-service-accounts/main.tf#61` file at parent level for network service account.
1. Re-apply bootstrap to update the role.

## 1-org

1. Add org policies related to cloud run at `1-org/envs/shared/org_policy.tf`

    ```hcl
    /******************************************
    Cloud Run
    *******************************************/

    module "cloudrun_allowed_ingress" {
    source  = "terraform-google-modules/org-policy/google"
    version = "~> 5.1"

    constraint        = "constraints/run.allowedIngress"
    organization_id   = local.organization_id
    folder_id         = local.folder_id
    policy_for        = local.policy_for
    policy_type       = "list"
    allow             = ["is:internal-and-cloud-load-balancing"]
    allow_list_length = 1
    }

    module "cloudrun_allowed_vpc_egress" {
    source  = "terraform-google-modules/org-policy/google"
    version = "~> 5.1"

    organization_id   = local.organization_id
    folder_id         = local.folder_id
    policy_for        = local.policy_for
    constraint        = "constraints/run.allowedVPCEgress"
    policy_type       = "list"
    allow             = ["private-ranges-only"]
    allow_list_length = 1
    }
    ```

1. Push the code to you repository in the branch you are working on (development for example).

## 2-environments

1. 1. Add `vpcaccess.googleapis.com` in `/policies/constraints/serviceusage_allow_basic_apis.yaml` file in your policy repository (gcp-policies) and push the code to it.
1. Add `vpcaccess.googleapis.com` on list in file `gcp-environments/modules/env_baseline/networking.tf#71`
1. Add `cloudkms.googleapis.com`on list in file `gcp-environments/modules/env_baseline/secrets.tf#32`
1. Push the code for the branch in the repository (gcp-environment)

## 4-projects

1. Add `run.googleapis.com` in `/policies/constraints/serviceusage_allow_basic_apis.yaml` file in your policy repository (gcp-policies) and push the code to it.
1. Duplicate the file `modules/base_env/example_restricted_shared_vpc_project.tf` and rename it to `example_restricted_shared_vpc_serverless_project` in you projects repository (gcp-projects).
1. Replace the code in `example_restricted_shared_vpc_serverless_project.tf` file with:

    ```hcl
    /**
    * Copyright 2021 Google LLC
    *
    * Licensed under the Apache License, Version 2.0 (the "License");
    * you may not use this file except in compliance with the License.
    * You may obtain a copy of the License at
    *
    * http://www.apache.org/licenses/LICENSE-2.0
    *
    * Unless required by applicable law or agreed to in writing, software
    * distributed under the License is distributed on an "AS IS" BASIS,
    * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    * See the License for the specific language governing permissions and
    * limitations under the License.
    */

    module "restricted_shared_vpc_serverless_project" {
    source                   = "../single_project" //path to repository
    org_id                   = var.org_id
    billing_account          = var.billing_account
    folder_id                = data.google_active_folder.env.name
    environment              = var.env
    vpc_type                 = "restricted"
    alert_spent_percents     = var.alert_spent_percents
    alert_pubsub_topic       = var.alert_pubsub_topic
    budget_amount            = var.budget_amount
    project_prefix           = var.project_prefix
    enable_hub_and_spoke     = var.enable_hub_and_spoke
    enable_cloudbuild_deploy = true
    cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
    sa_roles                 = ["roles/editor"]

    activate_apis = [
        "cloudresourcemanager.googleapis.com",
        "storage-api.googleapis.com",
        "serviceusage.googleapis.com",
        "run.googleapis.com",
        "cloudkms.googleapis.com",
        "iam.googleapis.com"
    ]
    vpc_service_control_attach_enabled = "true"
    vpc_service_control_perimeter_name = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${var.perimeter_name}"

    # Metadata

    project_suffix    = "serverless"
    application_name  = "${var.business_code}-serverless-application"
    billing_code      = "1234"
    primary_contact   = "example@example.com"
    secondary_contact = "example2@example.com"
    business_code     = var.business_code
    }
    ```

1. Add roles in `gcp-projects/modules/single_project/main.tf`

    ```hcl
    resource "google_folder_iam_member" "storage_admin" {

    count  = var.enable_cloudbuild_deploy ? 1 : 0
    folder = var.folder_id
    role   = "roles/storage.admin"
    member = "serviceAccount:${module.project.service_account_email}"
    }

    resource "google_folder_iam_member" "folder_network_viewer" {
    count  = var.enable_cloudbuild_deploy ? 1 : 0
    folder = var.folder_id
    role   = "roles/compute.networkViewer"
    member = "serviceAccount:${module.project.service_account_email}"
    }

    resource "google_folder_iam_member" "cloud_run_admin" {
    count  = var.enable_cloudbuild_deploy ? 1 : 0
    folder = var.folder_id
    role   = "roles/run.admin"
    member = "serviceAccount:${module.project.service_account_email}"
    }

    resource "google_folder_iam_member" "network_user" {
    count  = var.enable_cloudbuild_deploy ? 1 : 0
    folder = var.folder_id
    role   = "roles/compute.networkUser"
    member = "serviceAccount:${module.project.service_account_email}"
    }

    resource "google_folder_iam_member" "service_account_admin" {
    count  = var.enable_cloudbuild_deploy ? 1 : 0
    folder = var.folder_id
    role   = "roles/iam.serviceAccountAdmin"
    member = "serviceAccount:${module.project.service_account_email}"
    }

    resource "google_folder_iam_member" "compute_security_admin" {
    count  = var.enable_cloudbuild_deploy ? 1 : 0
    folder = var.folder_id
    role   = "roles/compute.securityAdmin"
    member = "serviceAccount:${module.project.service_account_email}"
    }

    resource "google_folder_iam_member" "load_balancer_admin" {
    count  = var.enable_cloudbuild_deploy ? 1 : 0
    folder = var.folder_id
    role   = "roles/compute.loadBalancerAdmin"
    member = "serviceAccount:${module.project.service_account_email}"
    }

    resource "google_folder_iam_member" "kms_admin" {
    count  = var.enable_cloudbuild_deploy ? 1 : 0
    folder = var.folder_id
    role   = "roles/cloudkms.admin"
    member = "serviceAccount:${module.project.service_account_email}"
    }
    ```

1. Push the code to you repository in the branch you are working on (development for example).

## 3-network

1. Add `run.googleapis.com` in file `modules/base_env/main.tf#65`  - `restricted_services` module variable in you network module (gcp-network)
1. Add `serviceAccount:terraform-proj-sa@<YOUR-SEED-PROJECT>.iam.gserviceaccount.com` as a member of the perimeter in file `modules/base_env/main.tf#66` - `members` module variable in you network module (gcp-network)
1. Add `serviceAccount:project-service-account@<YOUR-SERVERLESS-PROJECT>.iam.gserviceaccount.com` as a member of the perimeter in file `modules/base_env/main.tf#66` - `members` module variable in you network module (gcp-network)
1. Add `serviceAccount:<APP-CLOUDBUILD-PROJECT-NUMBER>@cloudbuild.gserviceaccount.com` as a member of the perimeter in file `modules/base_env/main.tf#66` - `members` module variable in you network module (gcp-network)
1. Add `secure-cloud-run-net` module in you `modules/base_env` module in you network module (gcp-network)

    ```hcl
    data "google_projects" "serverless_project" {
        filter = "parent.id:${split["/", data.google_active_folder.env.name](1)} labels.application_name=bu1-serverless-application labels.environment=${var.env} lifecycleState=ACTIVE"
    }

    module "serverless_network" {
    source                    = "../secure-cloud-run-net"
    connector_name            = "serverless-connector"
    subnet_name               = "sb-${var.environment_code}-serverless-${var.default_region1}"
    location                  = var.default_region1
    vpc_project_id            = local.restricted_project_id
    serverless_project_id     = data.google_projects.serverless_project.projects[0].project_id
    shared_vpc_name           = module.restricted_shared_vpc.network_name
    connector_on_host_project = true
    ip_cidr_range             = "10.8.0.0/28"
    }
    ```

1. Push code to the environment branch in gcp-network repository

## 5-app-infra

1. Add `secure-cloud-run-core` module in `/5-app-infra/modules/env_base/main.tf`

    ```hcl
    /**
    * Copyright 2021 Google LLC
    *
    * Licensed under the Apache License, Version 2.0 (the "License");
    * you may not use this file except in compliance with the License.
    * You may obtain a copy of the License at
    *
    * http://www.apache.org/licenses/LICENSE-2.0
    *
    * Unless required by applicable law or agreed to in writing, software
    * distributed under the License is distributed on an "AS IS" BASIS,
    * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    * See the License for the specific language governing permissions and
    * limitations under the License.
    */

    locals {
    environment_code = element(split("", var.environment), 0)
    key_name         = "secure-cloud-run"
    }

    resource "google_service_account" "cloudrun_service_account" {
    project      = data.google_project.env_project.project_id
    account_id   = "sa-example-app"
    display_name = "Example app service Account"
    }

    resource "google_service_account_iam_member" "run_identity_terraform_sa_impersonate_permissions" {
    service_account_id = google_service_account.cloudrun_service_account.id
    role               = "roles/iam.serviceAccountUser"
    member             = "serviceAccount:${google_project_service_identity.serverless_sa.email}"
    }

    resource "random_id" "kms_random" {
    byte_length = 4
    }

    module "kms" {
    source  = "terraform-google-modules/kms/google"
    version = "~> 2.2"

    project_id         = data.google_project.env_project.project_id
    keyring            = "kms-secure-cloud-run-${random_id.kms_random.hex}"
    location           = var.region
    keys               = [local.key_name]
    encrypters         = ["serviceAccount:${google_service_account.cloudrun_service_account.email}", "serviceAccount:${google_project_service_identity.serverless_sa.email}"]
    set_encrypters_for = [local.key_name]
    decrypters         = ["serviceAccount:${google_service_account.cloudrun_service_account.email}", "serviceAccount:${google_project_service_identity.serverless_sa.email}"]
    set_decrypters_for = [local.key_name]
    prevent_destroy    = "false"

    depends_on = [
        google_service_account.cloudrun_service_account,
        google_project_service_identity.serverless_sa
    ]
    }

    resource "google_kms_crypto_key_iam_binding" "decrypter" {
    role          = "roles/cloudkms.cryptoKeyDecrypter"
    crypto_key_id = "${data.google_project.env_project.project_id}/${var.region}/${module.kms.keyring_name}/${local.key_name}"
    members       = ["serviceAccount:${google_project_service_identity.serverless_sa.email}"]
    }

    resource "google_kms_crypto_key_iam_binding" "encrypter" {
    role          = "roles/cloudkms.cryptoKeyEncrypter"
    crypto_key_id = "${data.google_project.env_project.project_id}/${var.region}/${module.kms.keyring_name}/${local.key_name}"
    members       = ["serviceAccount:${google_project_service_identity.serverless_sa.email}"]
    }

    module "cloud_run_core" {

    # source = "GoogleCloudPlatform/cloud-run/google//modules/secure-cloud-run-core"

    source = "git::<https://github.com/GoogleCloudPlatform/terraform-google-cloud-run.git//modules/secure-cloud-run-core?ref=main>"

    service_name     = "example-secure-cloudrun"
    location         = var.region
    project_id       = data.google_project.env_project.project_id
    region           = var.region
    image            = "us-docker.pkg.dev/cloudrun/container/hello@sha256:717e538e1ef8f955a54834e213d080bde6a8b3513fcc406df0d5d5ed3ed2853b"
    cloud_run_sa     = google_service_account.cloudrun_service_account.email
    vpc_connector_id = "projects/${data.google_project.env_project.project_id}/locations/${var.region}/connectors/serverless-connector"
    encryption_key   = module.kms.keys[local.key_name]
    members          = ["user:amandak@clsecteam.com"]

    depends_on = [
        google_service_account_iam_member.run_identity_terraform_sa_impersonate_permissions,
        google_kms_crypto_key_iam_binding.decrypter,
        google_kms_crypto_key_iam_binding.encrypter
    ]
    }
    ```

1. Replace the code file in `/5-app-infra/modules/env_base/data.tf` for:

    ```hcl
    /**
    * Copyright 2021 Google LLC
    *
    * Licensed under the Apache License, Version 2.0 (the "License");
    * you may not use this file except in compliance with the License.
    * You may obtain a copy of the License at
    *
    * http://www.apache.org/licenses/LICENSE-2.0
    *
    * Unless required by applicable law or agreed to in writing, software
    * distributed under the License is distributed on an "AS IS" BASIS,
    * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    * See the License for the specific language governing permissions and
    * limitations under the License.
    */

    data "google_projects" "network_projects" {
    filter = "parent.id:${split["/", var.folder_id](1)} labels.application_name=${var.vpc_type}-shared-vpc-host labels.environment=${var.environment} lifecycleState=ACTIVE"
    }

    data "google_project" "network_project" {
    project_id = data.google_projects.network_projects.projects[0].project_id
    }

    data "google_projects" "environment_projects" {
    filter = "parent.id:${split["/", var.folder_id](1)} name:*${var.project_suffix}* labels.application_name=${var.business_code}-serverless-application labels.environment=${var.environment} lifecycleState=ACTIVE"
    }

    data "google_project" "env_project" {
    project_id = data.google_projects.environment_projects.projects[0].project_id
    }

    data "google_projects" "secrets_projects" {
    filter = "parent.id:${split["/", var.folder_id](1)} name:*${var.secrets_prj_suffix}* labels.application_name=${var.business_code}-sample-application labels.environment=${var.environment} lifecycleState=ACTIVE"
    }

    data "google_compute_network" "shared_vpc" {
    name    = "vpc-${local.environment_code}-shared-${var.vpc_type}"
    project = data.google_project.network_project.project_id
    }

    data "google_compute_subnetwork" "subnetwork" {
    name    = "sb-${local.environment_code}-shared-${var.vpc_type}-${var.region}"
    region  = var.region
    project = data.google_project.network_project.project_id
    }

    resource "google_project_service_identity" "serverless_sa" {
    provider = google-beta

    project = data.google_project.env_project.project_id
    service = "run.googleapis.com"
    }
    ```

1. Change the variables and outputs for modules and environments.
1. Push code to the app repository.
