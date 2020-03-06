data "template_file" "pks_ops_file" {
  template = "${chomp(file("${path.module}/templates/pks-config-ops.yml"))}"

  vars = {
    region     = var.region

    iam_instance_profile_master = aws_iam_instance_profile.pks_master.name
    iam_instance_profile_worker = aws_iam_instance_profile.pks_worker.name
    pks_api_lb_security_group   = "pks_lb_security_groups"
  }
}