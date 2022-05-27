# sbp-serverless-blueprint

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| connector\_name | The name of the serverless connector which is going to be created. | `string` | n/a | yes |
| connector\_on\_host\_project | Connector is going to be created on the host project if true. When false, connector is going to be created on service project. For more information, access [documentation](https://cloud.google.com/run/docs/configuring/connecting-shared-vpc). | `bool` | `true` | no |
| ip\_cidr\_range | The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported | `string` | n/a | yes |
| location | The location where resources are going to be deployed. | `string` | `"us-central1"` | no |
| serverless\_project\_id | The project where cloud run is going to be deployed. | `string` | n/a | yes |
| shared\_vpc\_name | Shared VPC name which is going to be used. | `string` | n/a | yes |
| subnet\_name | Subnet name to be re-used. | `string` | `null` | no |
| vpc\_project\_id | The project where shared vpc is. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| connector\_id | VPC serverless connector ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->