locals {
  pks_cidr      = cidrsubnet(module.pave.vpc_cidr, 4, 1)
  services_cidr = cidrsubnet(module.pave.vpc_cidr, 4, 2)
}

resource "google_compute_subnetwork" "pks" {
  name          = "${var.env_name}-pks-subnet"
  ip_cidr_range = local.pks_cidr
  network       = module.pave.network_name
  region        = var.region
}

resource "google_compute_subnetwork" "services" {
  name          = "${var.env_name}-services-subnet"
  ip_cidr_range = local.services_cidr
  network       = module.pave.network_name
  region        = var.region
}