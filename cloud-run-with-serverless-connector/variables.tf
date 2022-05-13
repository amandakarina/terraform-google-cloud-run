variable "terraform_service_account" {
  description = "The email address of the service account that will run the Terraform code."
  type        = string
}

variable "vpc_project" {
  description = "The Project ID for the host project of VPC, Firewalls and Shared VPC will"
  type        = string
}

variable "serverless_project" {
  description = "The Project ID for the host project of the Serverless Application"
  type        = string
}

variable "project_number" {
  description = "The Project Number of the serverless_project"
  type        = string
}