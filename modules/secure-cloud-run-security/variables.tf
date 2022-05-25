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

variable "kms_project_id" {
  description = "The project where KMS will be created."
  type        = string
}

variable "serverless_project_id" {
  description = "The project where Cloud Run is going to be deployed."
  type        = string
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys.."
  type        = bool
  default     = true
}

variable "keyring_name" {
  description = "Keyring name."
  type        = string
}

variable "key_rotation_period" {
  description = "Periodo or key rotatin in seconds."
  type        = string
  default     = "100000s"
}

variable "keys" {
  description = "Key names."
  type        = list(string)
}

variable "key_protection_level" {
  description = "The protection level to use when creating a version based on this template. Default value: \"SOFTWARE\" Possible values: [\"SOFTWARE\", \"HSM\"]"
  type        = string
  default     = "SOFTWARE"
}

variable "location" {
  description = "The location where resources are going to be deployed."
  type        = string
  default     = "us-central1"
}

variable "set_owners_for" {
  description = "Name of keys for which owners will be set."
  type        = list(string)
  default     = []
}

variable "owners" {
  description = "List of comma-separated owners for each key declared in set_owners_for."
  type        = list(string)
  default     = []
}

variable "set_encrypters_for" {
  description = "Name of keys for which encrypters will be set."
  type        = list(string)
  default     = []
}

variable "encrypters" {
  description = "List of comma-separated owners for each key declared in set_encrypters_for."
  type        = list(string)
  default     = []
}

variable "set_decrypters_for" {
  description = "Name of keys for which decrypters will be set."
  type        = list(string)
  default     = []
}

variable "decrypters" {
  description = "List of comma-separated owners for each key declared in set_decrypters_for."
  type        = list(string)
  default     = []
}
