// Allow open access between internal VMs for a PKS deployment
resource "aws_security_group" "pks_internal_security_group" {
  name        = "pks_internal_security_group"
  description = "PKS Internal Security Group"
  vpc_id      = module.pave.vpc_id

  ingress {
    cidr_blocks = ["${local.pks_cidr}", "${local.services_cidr}"]
    protocol    = "icmp"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["${local.pks_cidr}", "${local.services_cidr}"]
    protocol    = "tcp"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["${local.pks_cidr}", "${local.services_cidr}"]
    protocol    = "udp"
    from_port   = 0
    to_port     = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = map("Name", "${var.env_name}-pks-internal-security-group")
}

// Allow access to master nodes
resource "aws_security_group" "pks_master_security_group" {
  name        = "pks_master"
  description = "PKS Master Node Security Group"
  vpc_id      = module.pave.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 8443
    to_port     = 8443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = map("Name", "${var.env_name}-pks-master-security-group")
}