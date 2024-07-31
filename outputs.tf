output "registry_endpoint" {
  value = module.anypoint_fabrics.registry_endpoint
}

output "registry_user" {
  value = module.anypoint_fabrics.registry_user
}

output "registry_password" {
  value = module.anypoint_fabrics.registry_password
  sensitive = true
}

output "activation_data" {
  value = module.anypoint_fabrics.activation_data
}

output "minikube_instance_id" {
  value = module.minikube.instance_id
}

output "minikube_instance_public_ip" {
  value = module.minikube.public_ip
}