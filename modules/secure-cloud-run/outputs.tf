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
  description = "Name of the keyring."
  value       = module.cloud_run_security.keyring_name
}

output "keys" {
  description = "Map of key name => key self link."
  value       = module.cloud_run_security.keys
}

output "cloud_run_service" {
  description = "Cloud run service"
  value       = module.cloud_run_core.cloud_run_service
}
