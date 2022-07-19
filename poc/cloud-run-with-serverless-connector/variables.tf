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

variable "terraform_service_account" {
  description = "The email address of the service account that will run the Terraform code."
  type        = string
}

variable "vpc_project_id" {
  description = "The Project ID for the host project of VPC, Firewalls and Shared VPC will"
  type        = string
}

variable "serverless_project_id" {
  description = "The Project ID for the host project of the Serverless Application"
  type        = string
}

variable "serverless_project_number" {
  description = "The Project Number of the serverless_project"
  type        = string
}
