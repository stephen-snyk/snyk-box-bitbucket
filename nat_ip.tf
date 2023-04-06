resource "google_compute_address" "default" {
  name   = "my-test-static-ip-address"
  region = var.region1
}
