variable "names" {
  description = "List of names of clusters to build"
  type        = list(string)
  default     = []
}

variable "endpoints" {
  description = "List of cluster endpoints"
  type        = list(string)
  default     = []
}

variable "register_scripts" {
  description = "List of cluster registration scripts"
  type        = list(string)
  default     = []
}

variable "provisioner_host" {
  description = "The host of the paasify provisioner used to trigger the install the tile"
}

variable "provisioner_ssh_username" {
  description = "The host of the paasify provisioner used to trigger the install the tile"
}

variable "provisioner_ssh_private_key" {
  description = "The SSH private key of the paasify provisioner"
}

variable "blocker" {

}