data "template_file" "harbor_configuration" {
  template = "${chomp(file("${path.module}/templates/harbor-config.yml"))}"

  vars = {
    az_configuration = var.az_configuration
    az               = var.singleton_az
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

  blocker = module.pas.blocker
}