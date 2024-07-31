output "activation_data" {
  value = anypoint_fabrics.fabrics.activation_data
}

output "registry_endpoint" {
  value = data.anypoint_fabrics_helm_repo.repo.rtf_image_registry_endpoint
}

output "registry_user" {
  value = data.anypoint_fabrics_helm_repo.repo.rtf_image_registry_user
}

output "registry_password" {
  value = data.anypoint_fabrics_helm_repo.repo.rtf_image_registry_password
  sensitive = true
}

output "health" {
  value = data.anypoint_fabrics_health.health
}

