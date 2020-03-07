resource "random_string" "pks_password" {
  length  = 8
  special = false
}

data "template_file" "setup_pks" {
  template = "${chomp(file("${path.module}/templates/setup_pks.sh"))}"

  vars = {
    api_endpoint = var.api_domain
    pks_password = random_string.pks_password.result
  }
}

module "setup_pks" {
  name   = "setup_pks"
  script = data.template_file.setup_pks.rendered

  source = "github.com/niallthomson/paasify-core//run-script"

  provisioner_host            = var.provisioner_host
  provisioner_ssh_username    = var.provisioner_ssh_username
  provisioner_ssh_private_key = var.provisioner_ssh_private_key

  blocker = module.apply_changes.blocker
}