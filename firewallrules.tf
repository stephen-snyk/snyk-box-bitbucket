resource "google_project" "snyk-cx-se-demo" {
  name       = "tf-test-project"
  project_id = "ae-project"
  org_id     = "123456789"
}

resource "google_app_engine_application" "app" {
  project     = google_project.my_project.project_id
  location_id = "us-central"
}

resource "google_app_engine_firewall_rule" "rule" {
  project      = google_app_engine_application.app.project
  priority     = 1000
  action       = "ALLOW"
  source_range = "*"
}