terraform {
  required_providers {
    anypoint = {
      source = "mulesoft-anypoint/anypoint"
      version = "1.7.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Modules
module "anypoint_fabrics" {
  source        = "./anypoint-fabrics"
  client_id     = var.anypoint_client_id
  client_secret = var.anypoint_client_secret
  cplane        = var.anypoint_cplane
  org_id        = var.anypoint_org_id
  prefix        = var.prefix
}

module "minikube" {
  source           = "./aws-ec2-minikube"
  ami_id           = "ami-0c6d91e4a58c413a9" # Ubuntu AMI
  instance_type    = var.aws_instance_type
  key_name         = "${var.prefix}mini-keypair"
  public_key       = var.aws_public_key
  region           = var.aws_region
  profile          = var.aws_profile
  prefix           = var.prefix
  docker_registry  = module.anypoint_fabrics.registry_endpoint
  docker_username  = module.anypoint_fabrics.registry_user
  docker_password  = module.anypoint_fabrics.registry_password
  activation_data  = module.anypoint_fabrics.activation_data
  mule_license_key = var.mule_license_key
}
