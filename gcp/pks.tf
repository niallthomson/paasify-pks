data "template_file" "pks_ops_file" {
  template = "${chomp(file("${path.module}/templates/pks-config-ops.yml"))}"

  vars = {
    region = var.region

    project                          = var.project
    network_name                     = module.pave.network_name
    pks_master_service_account_email = google_service_account.pks_master_service_account.email
    pks_worker_service_account_email = google_service_account.pks_worker_service_account.email
  }
}