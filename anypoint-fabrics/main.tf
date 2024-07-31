terraform {
  required_providers {
    anypoint = {
      # source = "mulesoft-anypoint/anypoint"
      # version = "1.5.6"
      source = "anypoint.mulesoft.com/automation/anypoint"
      version = "1.6.2-SNAPSHOT"
    }
  }
}

provider "anypoint" {
  client_id = var.client_id             # optionally use ANYPOINT_CLIENT_ID env var
  client_secret = var.client_secret     # optionally use ANYPOINT_CLIENT_SECRET env var
  cplane= var.cplane
}