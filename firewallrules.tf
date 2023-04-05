module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.gcp_project_id
  network_name = "default"

  rules = [{
    name                    = "sperciballi-box"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = [var.my_subnet]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["sperciballi"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = [22,80,8080,443,7990]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
}
