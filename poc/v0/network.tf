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

module "serverless-connector" {
  source     = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  project_id = var.vpc_project_id
  vpc_connectors = [{
    name            = "serverless-vpc-connector"
    region          = var.location
    subnet_name     = null
    host_project_id = var.vpc_project_id
    machine_type    = "e2-micro"
    min_instances   = 2
    max_instances   = 7
    network         = var.shared_vpc_name
    ip_cidr_range   = "10.8.0.0/28"
    }
  ]
  depends_on = [
    google_project_service.serverless_project_apis,
    google_project_service.vpc_project_id_apis,
    google_project_iam_member.gca_sa_vpcaccess,
    google_project_iam_member.cloud_services
  ]
}

