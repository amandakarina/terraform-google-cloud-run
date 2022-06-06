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

variable "region" {
  description = "Location for load balancer and Cloud Run resources"
  default     = "us-central1"
}

variable "ssl" {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
  default     = true
}

variable "domain" {
  description = "Domain name to run the load balancer on. Used if `ssl` is `true`."
  type        = string
}

variable "lb-name" {
  description = "Name for load balancer and associated resources"
  default     = "run-lb"
}

variable "terraform_service_account" {
  description = "The email address of the service account that will run the Terraform code."
  type        = string
}

variable "location" {
  description = "The location where resources are going to be deployed."
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Name for Cloud Run service."
  type = string
  default = "hello-world-with-apis-test"
}

variable "vpc_project_id" {
  description = "The project where shared vpc is."
  type        = string
}

variable "kms_project_id" {
  description = "The project where KMS will be created."
  type        = string
}

variable "serverless_project_id" {
  description = "The project where cloud run is going to be deployed."
  type        = string
}

variable "shared_vpc_name" {
  description = "Shared VPC name."
  type        = string
}

variable "image" {
  description = "Image url to be deployed on Cloud Run."
  type        = string
}

variable "artifact_repository_project" {
  description = "Artifact Repository Project to grant serverless identity viewer role."
  type        = string
}

variable "artifact_repository_location" {
  description = "Artifact Repository location to grant serverless identity viewer role."
  type        = string
}

variable "artifact_repository_name" {
  description = "Artifact Repository name to grant serverless identity viewer role"
  type        = string
}

variable "cloud_run_sa" {
    description = "Service account to be used on Cloud Run."
    type = string
}

