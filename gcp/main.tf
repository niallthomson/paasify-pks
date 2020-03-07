provider "google" {
  region  = var.region
  project = var.project

  version = "~> 2.20.0"
}

resource "null_resource" "infra_blocker" {
  depends_on = [
    google_compute_firewall.pks_api_lb,
    google_compute_forwarding_rule.pks_api_lb_8443,
    google_compute_forwarding_rule.pks_api_lb_9021,
  ]
}

module "pave" {
  source = "github.com/niallthomson/paasify-core//pave/gcp"

  environment_name   = var.env_name
  region             = var.region
  availability_zones = var.availability_zones
  project            = var.project

  dns_suffix  = var.dns_suffix
  hosted_zone = var.dns_zone_name

  ops_manager_version = module.common.ops_manager_version
  ops_manager_build   = module.common.ops_manager_build

  pivnet_token = var.pivnet_token

  additional_cert_domains = ["*.pks", "harbor"]

  director_ops_file = data.template_file.director_ops_file.rendered

  blockers = [null_resource.infra_blocker.id]
}

resource "null_resource" "pave_blocker" {
  depends_on = [module.pave]
}

module "common" {
  source = "../common"

  pks_version        = var.pks_version
  tiles              = var.tiles
  iaas               = "google"
  availability_zones = module.pave.availability_zones

  api_domain    = replace(replace(google_dns_record_set.pks_api_dns.name, "/^\\*\\./", ""), "/\\.$/", "")
  harbor_domain = replace(replace(google_dns_record_set.harbor_dns.name, "/^\\*\\./", ""), "/\\.$/", "")

  api_elb_names    = formatlist("tcp:%s", [google_compute_target_pool.pks_api_lb.name])
  harbor_elb_names = []

  pks_ops_file    = data.template_file.pks_ops_file.rendered
  //harbor_ops_file = data.template_file.harbor_ops_file.rendered

  az_configuration = module.pave.az_configuration
  singleton_az     = var.availability_zones[0]

  tls_cert        = module.pave.cert_full_chain
  tls_private_key = module.pave.cert_key
  tls_ca_cert     = module.pave.cert_ca

  provisioner_host            = module.pave.provisioner_host
  provisioner_ssh_username    = module.pave.provisioner_ssh_username
  provisioner_ssh_private_key = module.pave.provisioner_ssh_private_key

  blocker = module.pave.blocker
}