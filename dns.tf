# DNS Records
#resource "cloudflare_record" "apex" {
#    zone_id = var.cloudflare_zone_id
#    name    = var.cloudflare_zone
#    value   = google_compute_instance.origin.network_interface.0.access_config.0.nat_ip
#    type    = "A"
#    proxied = true
#}

resource "cloudflare_record" "api" {
    zone_id = var.cloudflare_zone_id
    name    = "api"
    value   = google_compute_instance.origin.network_interface.0.access_config.0.nat_ip
    type    = "A"
    proxied = true
}

resource "cloudflare_record" "httpbin" {
    zone_id = var.cloudflare_zone_id
    name    = "httpbin"
    value   = "${cloudflare_argo_tunnel.auto_tunnel.id}.cfargotunnel.com"
#    value   = google_compute_instance.origin.network_interface.0.access_config.0.nat_ip
#    type    = "A"
    type    = "CNAME"
    proxied = true
}

resource "cloudflare_record" "internal" {
    zone_id = var.cloudflare_zone_id
    name    = "internal"
    value   = "10.0.0.1"
    type    = "A"
}

resource "cloudflare_record" "wild" {
    zone_id = var.cloudflare_zone_id
    name    = "*"
    value   = google_compute_instance.origin.network_interface.0.access_config.0.nat_ip
    type    = "A"
    proxied = true
}

resource "cloudflare_record" "system2" {
    zone_id = var.cloudflare_zone_id
    name    = "system2"
    value   = google_compute_instance.origin2.network_interface.0.access_config.0.nat_ip
    type    = "A"
    proxied = true
}

resource "cloudflare_record" "ssh_app" {
  zone_id = var.cloudflare_zone_id
  name    = "ssh"
  value   = "${cloudflare_argo_tunnel.auto_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "ssh_app2" {
  zone_id = var.cloudflare_zone_id
  name    = "ssh2"
  value   = "${cloudflare_argo_tunnel.auto_tunnel2.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

