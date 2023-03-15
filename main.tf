# Here is where we tell terraform which providers we want to use
provider "google" {
  project = var.gcp_project_id
}

provider "random" {
}
