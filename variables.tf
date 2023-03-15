# GCP variables
variable "gcp_project_id" {
  description = "Google Cloud Platform (GCP) Project ID."
  type        = string
}

variable "zone1" {
  description = "GCP zone name."
  type        = string
}

variable "machine_type" {
  description = "GCP VM instance machine type."
  type        = string
}