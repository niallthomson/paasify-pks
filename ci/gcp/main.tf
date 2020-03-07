provider "google" {
  project = "fe-nthomson"
  region  = "us-central1"
}

module "paasify" {
  source = "../../gcp"

  env_name           = "test123"
  project            = "fe-nthomson"
  region             = "us-central1"
  availability_zones = ["us-central1-a", "us-central1-b", "us-central1-c"]

  dns_suffix    = "gcp.paasify.org"
  dns_zone_name = "paasify-zone"

  pks_version = "1.6"
  tiles       = ["harbor"]

  pivnet_token = "mytoken123"
}