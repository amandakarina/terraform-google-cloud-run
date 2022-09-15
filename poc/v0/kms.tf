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

module "cloud_run_kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.1"

  project_id         = var.kms_project_id
  location           = var.location
  keyring            = "cloud-run-keyring"
  keys               = ["cloud_run"]
  set_decrypters_for = ["cloud_run"]
  set_encrypters_for = ["cloud_run"]
  decrypters = [
    "serviceAccount:${google_project_service_identity.serverless_sa.email}",
    "serviceAccount:${var.cloud_run_sa}"
  ]
  encrypters = [
    "serviceAccount:${google_project_service_identity.serverless_sa.email}",
    "serviceAccount:${var.cloud_run_sa}"
  ]
  prevent_destroy = false
}

module "artifact_registry_kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.1"

  project_id         = var.kms_project_id
  location           = var.location
  keyring            = "artifact-registry-key"
  keys               = ["artifact_registry"]
  set_decrypters_for = ["artifact_registry"]
  set_encrypters_for = ["artifact_registry"]
  decrypters = [
    "serviceAccount:${data.google_project.serverless_project.number}-compute@developer.gserviceaccount.com",
    "serviceAccount:${google_project_service_identity.serverless_sa.email}",
  ]
  encrypters = [
    "serviceAccount:${data.google_project.serverless_project.number}-compute@developer.gserviceaccount.com",
    "serviceAccount:${google_project_service_identity.serverless_sa.email}",
  ]
  prevent_destroy = false
}
