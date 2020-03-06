resource "aws_security_group" "harbor_lb_security_group" {
  name        = "harbor_lb_security_group"
  description = "Harbor LB Security Group"
  vpc_id      = module.pave.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = map("Name", "${var.env_name}-harbor-lb-security-group")
}

resource "aws_lb" "harbor" {
  name                             = "${var.env_name}-harbor"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  internal                         = false
  subnets                          = module.pave.public_subnet_ids
}

resource "aws_lb_listener" "harbor_443" {
  load_balancer_arn = aws_lb.harbor.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.harbor_443.arn}"
  }
}

resource "aws_lb_target_group" "harbor_443" {
  name     = "${var.env_name}-harbor-tg-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = module.pave.vpc_id

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 6
    interval            = 10
    protocol            = "TCP"
  }
}

resource "aws_lb_listener" "harbor_80" {
  load_balancer_arn = aws_lb.harbor.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.harbor_80.arn}"
  }
}

resource "aws_lb_target_group" "harbor_80" {
  name     = "${var.env_name}-harbor-tg-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = module.pave.vpc_id

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 6
    interval            = 10
    protocol            = "TCP"
  }
}

resource "aws_route53_record" "harbor_dns" {
  zone_id = module.pave.dns_zone_id
  name    = "harbor.${module.pave.base_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.harbor.dns_name
    zone_id                = aws_lb.harbor.zone_id
    evaluate_target_health = true
  }
}

data "template_file" "harbor_ops_file" {
  template = "${chomp(file("${path.module}/templates/harbor-config-ops.yml"))}"

  vars = {
    harbor_lb_security_group   = "harbor_lb_security_groups"
  }
}