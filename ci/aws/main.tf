module "paasify" {
  source = "../../aws"

  env_name           = "test123"
  region             = "us-west-2"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  dns_suffix = "aws.paasify.org"

  pks_version = "1.6"
  tiles       = ["harbor"]

  pivnet_token = "mytoken123"
}