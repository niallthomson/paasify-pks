variable "env_name" {
  description = "The name of the environment, used to name resources and DNS domains"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR of the AWS VPC that will be created for this foundation"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "The AWS region in which to deploy the foundation (ie. us-west-2)"
  type        = string
}

variable "dns_suffix" {
  description = "The suffix of the DNS domain that will be used (ie. aws.paasify.org)"
  type        = string
}

variable "availability_zones" {
  description = "List of AWS availability zones in which to deploy the foundation"
  type        = list(string)
}

variable "pivnet_token" {
  description = "Token for Pivotal Network used to download assets"
  type        = string
}

variable "ops_manager_instance_type" {
  description = "AWS EC2 instance type used for OpsManager"
  type        = string
  default     = "r4.large"
}

variable "pks_version" {
  description = "The major version of PKS to install (ie. 1.6)"
  type        = string
}

variable "tiles" {
  description = "List of names of tiles to install with PAS"
  type        = list(string)
  default     = []
}

variable "encrypt_pas_buckets" {
  description = "Apply KMS encryption to S3 buckets used for PAS"
  default     = "1"
}

variable "clusters" {
  description = "List of names of clusters to build automatically"
  type        = list(string)
  default     = []
}