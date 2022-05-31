/**
 * Copyright 2020 Google LLC
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

# provider "google" {
#   project = var.project_id
# }

# provider "google-beta" {
#   project = var.project_id
# }

# [START cloudloadbalancing_ext_http_cloudrun]
module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 5.1"
  name    = "tf-cr-lb"
  project = var.project_id #var.serverless_project

  ssl                             = var.ssl
  managed_ssl_certificate_domains = [var.domain]
  https_redirect                  = var.ssl

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        }
      ]
      enable_cdn              = false
      security_policy         = google_compute_security_policy.cloud-armor-security-policy.id
      custom_request_headers  = null
      custom_response_headers = null

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  provider              = google-beta
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.default.name
  }
}

resource "google_cloud_run_service" "default" {
  name     = "example" #module.cloud_run.service_name
  location = var.region
  project  = var.project_id #var.serverless_project

  template {
    spec {
      service_account_name = "project-service-account@prj-bu1-p-sample-restrict-f422.iam.gserviceaccount.com" #var.cloud_run_sa
      containers {
        #image = "gcr.io/cloudrun/hello"
        image = "us-central1-docker.pkg.dev/prj-bu1-p-sample-restrict-f422/serverless-central1-foundation2/cloudfunction--v2--foundation:latest" #var.image
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "public-access" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name
  role     = "roles/run.invoker"
  #member   = "allUsers"
  member = "serviceAccount:project-service-account@prj-bu1-p-sample-restrict-f422.iam.gserviceaccount.com" #"serviceAccount:${module.cloud_run.service_account_email}"
}
# [END cloudloadbalancing_ext_http_cloudrun]
