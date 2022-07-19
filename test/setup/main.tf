/**
 * Copyright 2019 Google LLC
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


provider "google" {
  impersonate_service_account = var.terraform_sa
}

provider "google-beta" {
  impersonate_service_account = var.terraform_sa
}

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name              = "ci-cloud-run"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  svpc_host_project_id               = var.host_project_id
  vpc_service_control_attach_enabled = true
  vpc_service_control_perimeter_name = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${var.vpc_service_control_perimeter_name}"

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "storage-api.googleapis.com",
    "serviceusage.googleapis.com",
    "run.googleapis.com",
    "cloudkms.googleapis.com",
    "iam.googleapis.com"
  ]

  labels = { "ci-project" : "cloud-run" }
}

module "kms_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name              = "ci-cloud-run-kms"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  activate_apis = [
    "cloudkms.googleapis.com",
    "iam.googleapis.com"
  ]

  labels = { "ci-project" : "cloud-run" }
}
