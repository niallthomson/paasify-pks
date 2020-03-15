# Create a new load balancer
resource "aws_elb" "clusters" {
  count = length(var.clusters)

  name               = "${var.env_name}-pks-cluster-${var.clusters[count.index]}"
  subnets            = module.pave.public_subnet_ids
  security_groups    = [aws_security_group.pks_master_security_group.id]

  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 8443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8443"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_route53_record" "clusters" {
  count = length(var.clusters)

  zone_id = module.pave.dns_zone_id
  name    = "${var.clusters[count.index]}.pks.${module.pave.base_domain}"
  type    = "A"

  alias {
    name                   = aws_elb.clusters[count.index].dns_name
    zone_id                = aws_elb.clusters[count.index].zone_id
    evaluate_target_health = true
  }
}

data "template_file" "cluster_registration_scripts" {
  count = length(var.clusters)

  template = "${chomp(file("${path.module}/templates/cluster-registration-script.sh"))}"

  vars = {
    lb_name = aws_elb.clusters[count.index].name
    region  = var.region
  }
}

module "clusters" {
  source = "../clusters"

  names            = var.clusters
  endpoints        = aws_route53_record.clusters.*.name
  register_scripts = data.template_file.cluster_registration_scripts.*.rendered

  provisioner_host            = module.pave.provisioner_host
  provisioner_ssh_username    = module.pave.provisioner_ssh_username
  provisioner_ssh_private_key = module.pave.provisioner_ssh_private_key

  blocker = module.common.blocker
}