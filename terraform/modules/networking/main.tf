resource "google_compute_address" "static_ip" {
  name   = "tf2c-static-ip"
  region = var.region
}

resource "google_compute_network" "vpc" {
  name                    = "tf2c-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "tf2c-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "rules" {
  name    = "tf2c-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "udp"
    ports    = ["27015"] # Game port
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]    # SSH
  }

  source_ranges = ["0.0.0.0/0"]
}