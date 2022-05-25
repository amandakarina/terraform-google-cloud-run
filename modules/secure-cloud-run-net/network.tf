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

module "serverless_connector" {
  source     = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  project_id = var.vpc_project
  vpc_connectors = [{
    name            = var.connector_name
    region          = var.location
    subnet_name     = var.subnet_name
    host_project_id = var.vpc_project
    machine_type    = "e2-micro"
    min_instances   = 2
    max_instances   = 7
    network         = var.shared_vpc_name
    ip_cidr_range   = "10.8.0.0/28"
    }
  ]
  depends_on = [
    google_project_iam_member.gca_sa_vpcaccess,
    google_project_iam_member.cloud_services
  ]
}

