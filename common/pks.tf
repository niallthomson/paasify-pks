locals {
  tls_full_chain = "${var.tls_cert}${var.tls_ca_cert}"
}

data "template_file" "pks_configuration" {
  template = "${chomp(file("${path.module}/templates/pks-config.yml"))}"

  vars = {
    az_configuration = var.az_configuration
    az               = var.singleton_az
    plan_azs         = join(", ", var.availability_zones)

    tls_cert        = "${jsonencode(local.tls_full_chain)}"
    tls_private_key = "${jsonencode(var.tls_private_key)}"
    tls_ca_cert     = "${jsonencode(var.tls_ca_cert)}"

    api_elb_names     = "${join(", ", var.api_elb_names)}"
    api_domain       = "${var.api_domain}"
  }
}

module "pks" {
  source = "github.com/niallthomson/paasify-core//opsmanager-tile"

  slug         = "pivotal-container-service"
  tile_version = local.tile_versions["pks"]
  //om_product   = "cf"
  //glob         = "srt"
  iaas         = var.iaas
  config       = data.template_file.pks_configuration.rendered
  ops_file     = var.pks_ops_file

  provisioner_host        = var.provisioner_host
  provisioner_username    = var.provisioner_ssh_username
  provisioner_private_key = var.provisioner_ssh_private_key

  blocker = var.blocker
}