resource "anypoint_fabrics" "fabrics" {
  org_id = var.org_id
  name = "${var.prefix}-rtf"
  region = var.region
  vendor = var.vendor
}


output "fabrics" {
  value = anypoint_fabrics.fabrics
}
