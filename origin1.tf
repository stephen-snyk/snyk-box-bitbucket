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
}

# Renders the data value passed above in metadata_startup_script
data "template_file" "server1" {
  template = file("./server.tpl")

  vars = {
  }
}

output "public_ip1" {
  value = google_compute_instance.origin1.network_interface[0]
}

output "instance_name" {
    value = random_id.namespace1.hex
}
