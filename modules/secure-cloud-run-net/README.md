# sbp-serverless-blueprint

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| connector\_name | The email address of the service account that will run the Terraform code. | `string` | n/a | yes |
| location | The location where resources are going to be deployed. | `string` | `"us-central1"` | no |
| serverless\_project | The project where cloud run is going to be deployed. | `string` | n/a | yes |
| shared\_vpc\_name | Shared VPC name which is going to be used. | `string` | n/a | yes |
| subnet\_name | Subnet name to be re-used. | `string` | `null` | no |
| vpc\_project | The project where shared vpc is. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| connector\_id | VPC serverless connector ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->