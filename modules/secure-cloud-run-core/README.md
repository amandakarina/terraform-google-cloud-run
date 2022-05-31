# Secure Cloud Run Core

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud\_run\_sa | Service account to be used on Cloud Run. | `string` | n/a | yes |
| encryption\_key | CMEK encryption key self-link expected in the format projects/PROJECT/locations/LOCATION/keyRings/KEY-RING/cryptoKeys/CRYPTO-KEY. | `string` | n/a | yes |
| env\_vars | Environment variables (cleartext) | <pre>list(object({<br>    value = string<br>    name  = string<br>  }))</pre> | `[]` | no |
| image | Image url to be deployed on Cloud Run. | `string` | n/a | yes |
| location | The location where resources are going to be deployed. | `string` | `"us-central1"` | no |
| members | Users/SAs to be given invoker access to the service | `list(string)` | `[]` | no |
| serverless\_project\_id | The project where cloud run is going to be deployed. | `string` | n/a | yes |
| service\_name | Shared VPC name. | `string` | n/a | yes |
| vpc\_connector\_id | VPC Connector id. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloud\_run\_service | Cloud run service |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->