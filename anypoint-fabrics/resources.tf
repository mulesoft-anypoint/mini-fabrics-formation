resource "anypoint_fabrics" "fabrics" {
  org_id = var.org_id
  name = "${var.prefix}-rtf"
  region = var.region
  vendor = var.vendor
}

resource "anypoint_fabrics_associations" "assoc" {
  org_id = var.org_id
  fabrics_id = anypoint_fabrics.fabrics.id

  associations {
    env_id = "sandbox"
    org_id = "all"
  }
}


output "fabrics" {
  value = anypoint_fabrics.fabrics
}
