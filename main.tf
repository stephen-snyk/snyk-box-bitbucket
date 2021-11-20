# Here is where we tell terraform which providers we want to use
provider "google" {
  project = var.gcp_project_id
}

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
       version = "3.3.0"
#      version = "2.18.0"
    }
  }
}
provider "cloudflare" {
  email = var.cloudflare_email
  api_key = var.cloudflare_token
  account_id = var.cloudflare_account_id
}


provider "random" {
}
