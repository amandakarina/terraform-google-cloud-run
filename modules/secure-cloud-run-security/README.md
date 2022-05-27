# sbp-serverless-blueprint

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| decrypters | List of comma-separated owners for each key declared in set\_decrypters\_for. | `list(string)` | `[]` | no |
| encrypters | List of comma-separated owners for each key declared in set\_encrypters\_for. | `list(string)` | `[]` | no |
| key\_protection\_level | The protection level to use when creating a version based on this template. Default value: "SOFTWARE" Possible values: ["SOFTWARE", "HSM"] | `string` | `"SOFTWARE"` | no |
| key\_rotation\_period | Periodo or key rotatin in seconds. | `string` | `"100000s"` | no |
| keyring\_name | Keyring name. | `string` | n/a | yes |
| keys | Key names. | `list(string)` | n/a | yes |
| kms\_project\_id | The project where KMS will be created. | `string` | n/a | yes |
| location | The location where resources are going to be deployed. | `string` | `"us-central1"` | no |
| owners | List of comma-separated owners for each key declared in set\_owners\_for. | `list(string)` | `[]` | no |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys.. | `bool` | `true` | no |
| serverless\_project\_id | The project where Cloud Run is going to be deployed. | `string` | n/a | yes |
| set\_decrypters\_for | Name of keys for which decrypters will be set. | `list(string)` | `[]` | no |
| set\_encrypters\_for | Name of keys for which encrypters will be set. | `list(string)` | `[]` | no |
| set\_owners\_for | Name of keys for which owners will be set. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| keyring | Self link of the keyring. |
| keyring\_name | Name of the keyring. |
| keyring\_resource | Keyring resource. |
| keys | Map of key name => key self link. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->