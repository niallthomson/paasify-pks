output "ops_manager_version" {
  value = local.ops_manager_version.version
}

output "ops_manager_build" {
  value = local.ops_manager_version.build
}

output "pks_admin_username" {
  description = "Admin username for PKS"
  value       = "paasify"
}

output "pks_admin_password" {
  description = "Admin username for PKS"
  value       = random_string.pks_password.result
}

output "harbor_admin_password" {
  description = "Harbor admin password"
  value       = random_string.harbor_password.result
}