resource "random_id" "namespace1" {
  prefix      = "sperciballi-box-"
  byte_length = 2
}

data "google_compute_image" "image" {
  family  = "ubuntu-minimal-1804-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "origin1" {
  name         = random_id.namespace1.hex
  machine_type = var.machine_type
  zone         = var.zone1
  tags         = ["sperciballi", "ssh", "https-server"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
  metadata_startup_script = data.template_file.server.rendered
  metadata = {
      snyk-terraform = "sperciballi-box"
  }
}


# Renders the data value passed above in metadata_startup_script
data "template_file" "server" {
  template = "${file("${path.module}/server.tpl")}"
  vars =  {
    snyk_broker_token = "${var.snyk_broker_token}"
    bitbucket_username = "${var.bitbucket_username}"
    bitbucket_password = "${var.bitbucket_password}"
#    network_ip = "${google_compute_instance.origin1.network_interface[0].network_ip}"
  }
}

output "public_ip1" {
  value = google_compute_instance.origin1.network_interface[0]
}

output "instance_name" {
    value = random_id.namespace1.hex
}
