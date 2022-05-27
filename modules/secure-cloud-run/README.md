# sbp-serverless-blueprint

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| artifact\_repository\_location | Artifact Repository location to grant serverless identity viewer role. | `string` | n/a | yes |
| artifact\_repository\_name | Artifact Repository name to grant serverless identity viewer role | `string` | n/a | yes |
| artifact\_repository\_project | Artifact Repository Project to grant serverless identity viewer role. | `string` | n/a | yes |
| cloud\_run\_sa | Service account to be used on Cloud Run. | `string` | n/a | yes |
| connector\_name | The email address of the service account that will run the Terraform code. | `string` | n/a | yes |
| env\_vars | Environment variables (cleartext) | <pre>list(object({<br>    value = string<br>    name  = string<br>  }))</pre> | `[]` | no |
| image | Image url to be deployed on Cloud Run. | `string` | n/a | yes |
| key\_name | The name of KMS Key to be created and used in Cloud Run. | `string` | n/a | yes |
| key\_protection\_level | The protection level to use when creating a version based on this template. Default value: "SOFTWARE" Possible values: ["SOFTWARE", "HSM"] | `string` | `"SOFTWARE"` | no |
| key\_rotation\_period | Periodo or key rotatin in seconds. | `string` | `"100000s"` | no |
| keyring\_name | Keyring name. | `string` | n/a | yes |
| kms\_project\_id | The project where KMS will be created. | `string` | n/a | yes |
| location | The location where resources are going to be deployed. | `string` | `"us-central1"` | no |
| members | Users/SAs to be given invoker access to the service | `list(string)` | `[]` | no |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys.. | `bool` | `true` | no |
| serverless\_project\_id | The project where cloud run is going to be deployed. | `string` | n/a | yes |
| service\_name | Shared VPC name. | `string` | n/a | yes |
| shared\_vpc\_name | Shared VPC name which is going to be used. | `string` | n/a | yes |
| subnet\_name | Subnet name to be re-used. | `string` | `null` | no |
| vpc\_project\_id | The project where shared vpc is. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloud\_run\_service | Cloud run service |
| connector\_id | VPC serverless connector ID. |
| keyring | Name of the keyring. |
| keys | Map of key name => key self link. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->