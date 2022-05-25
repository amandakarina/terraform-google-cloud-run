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

module "cloud_run_network" {
  source             = "../secure-cloud-run-net"
  connector_name     = var.connector_name
  subnet_name        = var.subnet_name
  location           = var.location
  vpc_project        = var.vpc_project
  serverless_project = var.serverless_project
  shared_vpc_name    = var.shared_vpc_name
}

resource "google_project_service_identity" "serverless_sa" {
  provider = google-beta
  project  = var.serverless_project
  service  = "run.googleapis.com"
}

resource "google_artifact_registry_repository_iam_member" "artifact-registry-iam" {
  provider   = google-beta
  project    = var.artifact_repository_project
  location   = var.artifact_repository_location
  repository = var.artifact_repository_name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_project_service_identity.serverless_sa.email}"
}

module "cloud_run_security" {
  source               = "../secure-cloud-run-security"
  kms_project          = var.kms_project
  location             = var.location
  serverless_project   = var.serverless_project
  prevent_destroy      = var.prevent_destroy
  keys                 = [var.key_name]
  keyring_name         = var.keyring_name
  key_rotation_period  = var.key_rotation_period
  key_protection_level = var.key_protection_level
  set_encrypters_for   = [var.key_name]
  encrypters = [
    "serviceAccount:${google_project_service_identity.serverless_sa.email}",
    "serviceAccount:${var.cloud_run_sa}"
  ]
  set_decrypters_for = [var.key_name]
  decrypters = [
    "serviceAccount:${google_project_service_identity.serverless_sa.email}",
    "serviceAccount:${var.cloud_run_sa}"
  ]
}

module "cloud_run_core" {
  source             = "../secure-cloud-run-core"
  service_name       = var.service_name
  location           = var.location
  serverless_project = var.serverless_project
  image              = var.image
  cloud_run_sa       = var.cloud_run_sa
  vpc_connector_id   = module.cloud_run_network.connector_id
  encryption_key     = module.cloud_run_security.keys[var.key_name]
  env_vars           = var.env_vars
  members            = var.members
}
