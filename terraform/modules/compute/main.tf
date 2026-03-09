resource "google_compute_instance" "vm" {
  name         = "tf2c-server"
  machine_type = "n4-custom-2-8192"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "projects/tf2c-489120/global/images/nixos-stable-tf2c"
      type  = "hyperdisk-balanced"
      size  = 30
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    nic_type   = "GVNIC"

    access_config {
      nat_ip = var.server_ip
    }
  }

  allow_stopping_for_update = true

  metadata = {
  ssh-keys           = "tf2:${file(pathexpand("~/.ssh/id_ed25519.pub"))}"
  serial-port-enable = "TRUE"
}

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}

output "server_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}