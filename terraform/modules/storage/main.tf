data "google_storage_bucket" "images" {
  name = "tf2c-bucket-a52a4b7e" 
}

output "bucket_name" { value = data.google_storage_bucket.images.name }