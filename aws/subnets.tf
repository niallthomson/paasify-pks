locals {
  pks_cidr      = cidrsubnet(module.pave.vpc_cidr, 4, 2)
  services_cidr = cidrsubnet(module.pave.vpc_cidr, 4, 3)
}

resource "aws_subnet" "pks_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = module.pave.vpc_id
  cidr_block        = cidrsubnet(local.pks_cidr, 4, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.env_name}-ert-subnet${count.index}"
  }
}

resource "aws_route_table_association" "route_pks_subnets" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.pks_subnets[*].id, count.index)
  route_table_id = element(module.pave.route_table_ids, count.index)
}

resource "aws_subnet" "services_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = module.pave.vpc_id
  cidr_block        = cidrsubnet(local.services_cidr, 4, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    "Name" = "${var.env_name}-services-subnet${count.index}"
  }
}

resource "aws_route_table_association" "route_services_subnets" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.services_subnets[*].id, count.index)
  route_table_id = element(module.pave.route_table_ids, count.index)
}