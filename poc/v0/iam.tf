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

resource "google_project_iam_member" "run_identity_services" {
  project = var.vpc_project_id
  role    = "roles/vpcaccess.user"
  member     = "serviceAccount:${google_project_service_identity.serverless_sa.email}"
}

resource "google_project_service_identity" "vpcaccess_sa" {
  provider = google-beta
  project  = var.serverless_project_id
  service  = "vpcaccess.googleapis.com"
}

resource "google_project_iam_member" "gca_sa_vpcaccess" {
  project = var.vpc_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_project_service_identity.vpcaccess_sa.email}"
}

resource "google_project_iam_member" "cloud_services" {
  project = var.vpc_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${data.google_project.serverless_project.number}@cloudservices.gserviceaccount.com"
}

resource "google_artifact_registry_repository_iam_member" "artifact-registry-iam" {
  provider   = google-beta
  project    = var.artifact_repository_project
  location   = var.artifact_repository_location
  repository = var.artifact_repository_name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_project_service_identity.serverless_sa.email}"
}

resource "google_cloud_run_service_iam_member" "public-access" {
  location = var.location
  project  = var.serverless_project_id
  service  = var.service_name
  role     = "roles/run.invoker"
  member = "serviceAccount:${var.cloud_run_sa}"
}

