provider "aws" {
  region = var.region

  version = "~> 2.50.0"
}

data "aws_caller_identity" "current" {}

resource "null_resource" "infra_blocker" {
  depends_on = [
    aws_route53_record.pks_api_dns,
    aws_lb_listener.pks_api_9021,
    aws_lb_listener.pks_api_8443,
    aws_route_table_association.route_pks_subnets,
    aws_route_table_association.route_services_subnets,
  ]
}

module "pave" {
  source = "github.com/niallthomson/paasify-core//pave/aws"

  environment_name        = var.env_name
  region                  = var.region
  availability_zones      = var.availability_zones
  dns_suffix              = var.dns_suffix
  additional_cert_domains = ["*.pks"]
  ops_manager_version     = module.common.ops_manager_version
  ops_manager_build       = module.common.ops_manager_build
  pivnet_token            = var.pivnet_token
  director_ops_file       = data.template_file.director_ops_file.rendered

  blockers = [null_resource.infra_blocker.id]
}

resource "null_resource" "pave_blocker" {
  depends_on = [module.pave]
}

module "common" {
  source = "../common"

  pks_version        = var.pks_version
  tiles              = var.tiles
  iaas               = "aws"
  availability_zones = module.pave.availability_zones
  auto_apply         = var.auto_apply

  api_domain = aws_route53_record.pks_api_dns.name

  api_elb_names = formatlist("alb:%s", concat(aws_lb_target_group.pks_api_9021.*.name, aws_lb_target_group.pks_api_8443.*.name))

  pks_ops_file    = data.template_file.pks_ops_file.rendered
  harbor_ops_file = data.template_file.harbor_ops_file.rendered

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