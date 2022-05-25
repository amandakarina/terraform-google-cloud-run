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

variable "location" {
  description = "The location where resources are going to be deployed."
  type        = string
  default     = "us-central1"
}

variable "vpc_project" {
  description = "The project where shared vpc is."
  type        = string
}

variable "serverless_project" {
  description = "The project where cloud run is going to be deployed."
  type        = string
}

variable "connector_name" {
  description = "The email address of the service account that will run the Terraform code."
  type        = string
}

variable "subnet_name" {
  description = "Subnet name to be re-used."
  type        = string
  default     = null
}

variable "shared_vpc_name" {
  description = "Shared VPC name which is going to be used."
  type        = string
}
