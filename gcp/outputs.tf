output "ops_manager_domain" {
  description = "Domain for accessing OpsManager"
  value       = module.pave.ops_manager_domain
}

output "ops_manager_username" {
  description = "Username for accessing OpsManager"
  value       = module.pave.ops_manager_username
}

output "ops_manager_password" {
  description = "Password for accessing OpsManager"
  value       = module.pave.ops_manager_password
}

output "ops_manager_ssh_private_key" {
  description = "SSH private key for accessing OpsManager"
  value       = module.pave.ops_manager_ssh_private_key
}

output "pks_api_endpoint" {
  description = "API endpoint for PKS"
  value       = "https://${local.api_domain}:9021"
}

output "pks_admin_username" {
  description = "Admin username for PKS"
  value       = module.common.pks_admin_username
}

output "pks_admin_password" {
  description = "Admin username for PKS"
  value       = module.common.pks_admin_password
}

output "harbor_endpoint" {
  description = "Harbor endpoint"
  value       = "https://${local.harbor_domain}"
}

output "harbor_admin_password" {
  description = "Harbor admin password"
  value       = module.common.harbor_admin_password
}

output "provisioner_host" {
  description = "Hostname for accessing provisioner instance"
  value       = module.pave.provisioner_host
}

output "provisioner_ssh_username" {
  description = "SSH username for accessing provisioner instance"
  value       = module.pave.provisioner_ssh_username
}

output "provisioner_ssh_private_key" {
  description = "SSH password for accessing provisioner instance"
  value       = module.pave.provisioner_ssh_private_key
}