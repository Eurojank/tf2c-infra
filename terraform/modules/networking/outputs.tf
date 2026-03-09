output "subnet_id"         { value = google_compute_subnetwork.subnet.id }
output "static_ip_address" { value = google_compute_address.static_ip.address }