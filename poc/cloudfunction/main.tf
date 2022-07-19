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

resource "google_storage_bucket" "bucket" {
  provider                    = google-beta
  project                     = var.cloudfunction_project_id
  name                        = var.bucket_name
  location                    = var.location
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object" {
  provider = google-beta
  name     = "function-source.zip"
  bucket   = google_storage_bucket.bucket.name
  source   = "index.zip"
}

resource "google_cloudfunctions2_function" "function-v2" {
  provider = google-beta
  name     = var.function_name
  project  = var.cloudfunction_project_id
  location = var.location
  build_config {
    runtime           = "nodejs12"
    entry_point       = "helloHttp"
    docker_repository = google_artifact_registry_repository.my-repo.id
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }
  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}

resource "google_artifact_registry_repository" "my-repo" {
  provider      = google-beta
  location      = var.location
  project       = var.cloudfunction_project_id
  repository_id = var.artifact_registry_repository
  format        = "DOCKER"
  kms_key_name  = var.kms_key_name
}

data "google_project" "kms_project_id" {
  project_id = var.cloudfunction_project_id
}
resource "google_project_service_identity" "kms_sa" {
  provider = google-beta
  project  = data.google_project.kms_project_id.project_id
  service  = "artifactregistry.googleapis.com"
}
resource "google_project_iam_member" "kms_sa_EncrypterDecrypter" {
  project = var.kms_project_id_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${google_project_service_identity.kms_sa.email}"
}
resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = var.kms_key_name
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.kms_sa.email}"
}

resource "google_artifact_registry_repository_iam_member" "test-iam" {
  provider   = google-beta
  project    = var.cloudfunction_project_id
  location   = google_artifact_registry_repository.my-repo.location
  repository = google_artifact_registry_repository.my-repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_project_service_identity.kms_sa.email}"
}

