resource "cloudflare_load_balancer_monitor" "get-root-https" {
  expected_body = "alive"
  expected_codes = "200"
  method	= "GET"
  timeout	= 5
  path		= "/"
  interval	= 60
  retries	= 2
  description	= "GET / over HTTPS - expect 200"
}

resource "cloudflare_load_balancer_pool" "www-servers" {
  name		= "www-servers"
  monitor 	= cloudflare_load_balancer_monitor.get-root-https.id
  origins {
    name	= "www-canada"
    address	= google_compute_instance.origin.network_interface.0.access_config.0.nat_ip
  }
  origins {
    name	= "www-uswest"
    address	= google_compute_instance.origin2.network_interface.0.access_config.0.nat_ip
  }
  description	= "www origins"
  enabled	= true
  minimum_origins	= 1
}

resource "cloudflare_load_balancer" "www-lb" {
  zone_id	= var.cloudflare_zone_id
  name		= "www-lb.${var.cloudflare_zone}"
  default_pool_ids	= [cloudflare_load_balancer_pool.www-servers.id]
  fallback_pool_id	= cloudflare_load_balancer_pool.www-servers.id
  description		= "demo load balancer"
  proxied		= true
}

