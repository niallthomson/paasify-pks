module "pks_network_config" {
  source = "github.com/niallthomson/paasify-core//build-network-config/gcp"

  subnet_name    = google_compute_subnetwork.pks.name
  network_name   = module.pave.network_name
  region         = var.region
  subnet_cidr    = google_compute_subnetwork.pks.ip_cidr_range
  subnet_gateway = google_compute_subnetwork.pks.gateway_address
  subnet_azs     = var.availability_zones
}

module "services_network_config" {
  source = "github.com/niallthomson/paasify-core//build-network-config/gcp"

  subnet_name    = google_compute_subnetwork.services.name
  network_name   = module.pave.network_name
  region         = var.region
  subnet_cidr    = google_compute_subnetwork.services.ip_cidr_range
  subnet_gateway = google_compute_subnetwork.services.gateway_address
  subnet_azs     = var.availability_zones
}

data "template_file" "director_ops_file" {
  template = "${chomp(file("${path.module}/templates/director-ops-file.yml"))}"

  vars = {
    pks_subnets      = module.pks_network_config.subnet_config
    services_subnets = module.services_network_config.subnet_config
  }
}