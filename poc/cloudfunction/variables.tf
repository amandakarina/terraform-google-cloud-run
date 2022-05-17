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

variable "bucket_name" {
  type        = string
}

variable "cloudfunction_project_id" {
  type        = string
}

variable "kms_project_id" {
  type        = string
}

variable "location" {
  type        = string
}

variable "function_name" {
  type        = string
}

variable "artifact_registry_repository" {
  type        = string
}

variable "kms_key_name" {
  type        = string
}

variable "account_id" {
  type        = string
}
