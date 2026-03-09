module "storage" {
  source             = "./modules/storage"
  bucket_name_prefix = var.bucket_name_prefix
  bucket_location    = var.bucket_location
}

module "network" {
  source = "./modules/networking"
  region = var.region
}

module "compute" {
  source         = "./modules/compute"
  project_id     = var.project_id
  region         = var.region
  subnet_id      = module.network.subnet_id
  bucket_name    = module.storage.bucket_name
  server_ip      = module.network.static_ip_address
  ssh_public_key = var.ssh_public_key
}