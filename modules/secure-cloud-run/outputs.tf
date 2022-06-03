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

output "connector_id" {
  description = "VPC serverless connector ID."
  value       = module.cloud_run_network.connector_id
}

output "keyring" {
  description = "Name of the Cloud KMS keyring."
  value       = module.cloud_run_security.keyring_name
}

output "keys" {
  description = "Name of the Cloud KMS crypto key"
  value       = module.cloud_run_security.key
}

output "service_name" {
  value       = module.cloud_run_core.service_name
  description = "Name of the created service"
}
