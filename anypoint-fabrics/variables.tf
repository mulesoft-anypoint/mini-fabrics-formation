variable "prefix" {
  type = string
  description = "The prefix name"
}

variable "cplane" {
  type        = string
  default     = "us"
  description = "Anypoint control plane"
}

variable "org_id" {
  type        = string
  default     = ""
  description = "the anypoint organization id"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "the anypoint region"
}

variable "vendor" {
  type        = string
  default     = "eks"
  description = "the runtime fabrics vendor"
}

variable "client_id" {
  type        = string
  default     = ""
  description = "the client id of the anypoint user"
}

variable "client_secret" {
  type        = string
  default     = ""
  description = "the client secret of the anypoint user"
}