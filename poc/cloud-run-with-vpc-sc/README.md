# Using Cloud Run with KMS and Artifact Registry

Code for POC to demonstrate how to run the Secure Cloud Run with a VPC Service Perimeter and using KMS and Artifact Registry.

## Versions

- terraform
  - ```>= 0.13```
- google
  - ```~> 3.77```
- google-beta
  - ```~> 3.77```

## How to run

To use KSM and Artifact Registry with this example and the module you should:
1. Rename `terraform.example.tfvars` to `terraform.tfvars` and update the file with values from your environment:
    ```
    mv terraform.example.tfvars terraform.tfvars
    ```
1. Run `terraform init` and `terraform apply` to create the Service Perimenter.
1. Add the following *egress_rules* variable to the `terraform.tfvars` and rerun `terraform apply`.

```hcl
egress_policies = [
  {
    "from" = {
      "identity_type" = ""
      "identities"    = ["serviceAccount:<SERVERLESS-PROJECT-NUMBER>-compute@developer.gserviceaccount.com"]
    },
    "to" = {
      "resources" = ["projects/<SECURITY-PROJECT-NUMBER>"]
      "operations" = {
        "cloudkms.googleapis.com" = {
          "methods" = ["*"]
        }
        "artifactregistry.googleapis.com" = {
          "methods" = [
            "artifactregistry.googleapis.com/DockerRead"
          ]
        }
      }
    }
  },
]
```

## Deleting project

Run the command ``terraform destroy`` on your terminal to destroy the infrastructure created on this POC.