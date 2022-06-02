# Secure Cloud Run Core

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud\_run\_sa | Service account to be used on Cloud Run. | `string` | n/a | yes |
| encryption\_key | CMEK encryption key self-link expected in the format projects/PROJECT/locations/LOCATION/keyRings/KEY-RING/cryptoKeys/CRYPTO-KEY. | `string` | n/a | yes |
| env\_vars | Environment variables (cleartext) | <pre>list(object({<br>    value = string<br>    name  = string<br>  }))</pre> | `[]` | no |
| image | GCR hosted image URL to deploy | `string` | n/a | yes |
| location | The location where resources are going to be deployed. | `string` | n/a | yes |
| members | Users/SAs to be given invoker access to the service with the prefix `serviceAccount:' for SAs and `user:` for users.` | `list(string)` | `[]` | no |
| serverless\_project\_id | The project where cloud run is going to be deployed. | `string` | n/a | yes |
| service\_name | The name of the Cloud Run service to create | `string` | n/a | yes |
| vpc\_connector\_id | VPC Connector id in the forma projects/PROJECT/locations/LOCATION/connectors/NAME. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| domain\_map\_id | Unique Identifier for the created domain map |
| domain\_map\_status | Status of Domain mapping |
| location | Location in which the Cloud Run service was created |
| project\_id | Google Cloud project in which the service was created |
| revision | Deployed revision for the service |
| service\_id | Unique Identifier for the created service |
| service\_name | Name of the created service |
| service\_status | Status of the created service |
| service\_url | The URL on which the deployed service is available |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->