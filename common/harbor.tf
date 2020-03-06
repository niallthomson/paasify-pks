resource "random_string" "harbor_password" {
  length  = 8
  special = false
}

data "template_file" "harbor_configuration" {
  template = "${chomp(file("${path.module}/templates/harbor-config.yml"))}"

  vars = {
    az_configuration = var.az_configuration
    az               = var.singleton_az

    harbor_elb_names = join(", ", var.harbor_elb_names)
    harbor_domain    = var.harbor_domain
    tls_cert         = jsonencode(local.tls_full_chain)
    tls_private_key  = jsonencode(var.tls_private_key)
    tls_ca_cert      = jsonencode(var.tls_ca_cert)
    admin_password   = random_string.harbor_password.result
  }
}

module "harbor" {
  source = "github.com/niallthomson/paasify-core//opsmanager-tile"

  slug         = "harbor-container-registry"
  tile_version = local.tile_versions["harbor"]
  iaas         = var.iaas
  config       = data.template_file.harbor_configuration.rendered
  ops_file     = var.harbor_ops_file

  provisioner_host        = var.provisioner_host
  provisioner_username    = var.provisioner_ssh_username
  provisioner_private_key = var.provisioner_ssh_private_key

  skip = contains(var.tiles, "harbor") ? false : true

  blocker = module.pks.blocker
}