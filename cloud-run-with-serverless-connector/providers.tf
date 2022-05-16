provider "google" {
  impersonate_service_account = var.terraform_service_account
  request_timeout             = "60s"
}

provider "google-beta" {
  impersonate_service_account = var.terraform_service_account
  request_timeout             = "60s"
}