output "bucket_name" {
  description = "Created GCS bucket name"
  value       = module.storage.bucket_name
}

output "bucket_url" {
  description = "GCS bucket URL"
  value       = "gs://${module.storage.bucket_name}"
}

output "tf2c_server_public_ip" {
  value = module.compute.server_ip
}