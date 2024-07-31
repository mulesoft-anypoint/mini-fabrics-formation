data "anypoint_fabrics_health" "health" {
  fabrics_id = anypoint_fabrics.fabrics.id
  org_id = var.org_id
}

data "anypoint_fabrics_helm_repo" "repo" {
  org_id = var.org_id
}

# data "anypoint_fabrics" "instance" {
#   fabrics_id = anypoint_fabrics.fabrics.id
#   org_id = var.org_id
# }