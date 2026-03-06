resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "images" {
  name     = "${var.bucket_name_prefix}-${random_id.bucket_suffix.hex}"
  location = var.bucket_location

  uniform_bucket_level_access = true
  force_destroy               = false
}