data "template_file" "clusters" {
  count = length(var.names)

  template = "${chomp(file("${path.module}/templates/create.sh"))}"

  vars = {
    name            = var.names[count.index]
    endpoint        = var.endpoints[count.index]
    register_script = var.register_scripts[count.index]
  }
}

module "create_clusters" {
  name   = "create_clusters"
  script = join("\n", data.template_file.clusters.*.rendered)

  source = "github.com/niallthomson/paasify-core//run-script"

  provisioner_host            = var.provisioner_host
  provisioner_ssh_username    = var.provisioner_ssh_username
  provisioner_ssh_private_key = var.provisioner_ssh_private_key

  blocker = var.blocker
}