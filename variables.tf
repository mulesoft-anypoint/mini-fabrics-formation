variable "prefix" {
  type        = string
  description = "The prefix name"
}

variable "anypoint_cplane" {
  type        = string
  default     = "us"
  description = "anypoint control plane"
}

variable "anypoint_client_id" {
  type        = string
  description = "the client id of the anypoint user"
}

variable "anypoint_client_secret" {
  type        = string
  description = "the client secret of the anypoint user"
}

variable "anypoint_org_id" {
  type        = string
  description = "the anypoint root organization id"
}

variable "anypoint_env_id" {
  type        = string
  default     = "7074fcdd-9b23-4ab3-97c8-5db5f4adf17d"
  description = "the anypoint environment id"
}

variable "mule_license_key" {
  type = string
  description = "MuleSoft Runtime Fabrics license key in base64."
}

variable "aws_profile" {
  type = string
}

variable "aws_public_key" {
  description = "The public key to be used for the key pair."
  type        = string
}

variable "aws_instance_type" {
  type        = string
  description = "the aws ec2 instance type"
  default     = "t3.medium"
}

variable "aws_ami_id" {
  type        = string
  description = "the aws ec2 ami id"
  default     = "ami-0c6d91e4a58c413a9" #Ubuntu
}

variable "aws_region" {
  type        = string
  description = "the aws region"
  default     = "eu-west-1"
}
