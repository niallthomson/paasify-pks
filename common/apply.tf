locals {
  tile_versions = var.tile_versions[var.pks_version]
  apply_blockers = [
    module.pks.blocker,
    module.harbor.blocker,
  ]
  apply_blocker = sha256(join("", local.apply_blockers))
}

module "apply_changes" {
  source = "github.com/niallthomson/paasify-core//apply-changes"

  auto_apply = var.auto_apply

  provisioner_host            = var.provisioner_host
  provisioner_ssh_username    = var.provisioner_ssh_username
  provisioner_ssh_private_key = var.provisioner_ssh_private_key

  blocker = local.apply_blocker
}