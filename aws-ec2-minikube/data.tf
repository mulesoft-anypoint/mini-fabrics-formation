locals {
  azs_count = 1
  azs_names = data.aws_availability_zones.available.names

  #Preparing parts
  ec2_launch_script_parts = [
    {
      filepath = "${path.module}/resources/init.sh"
      content-type = "text/x-shellscript"
      vars = {
        cluster_name     = "${var.prefix}-mini-rtf-cluster"
        cluster_nodes    = var.cluster_nodes
        kube_version     = var.kube_version
        rtf_version      = var.rtf_version
        docker_registry  = var.docker_registry
        docker_username  = var.docker_username
        docker_password  = var.docker_password
        activation_data  = var.activation_data
        mule_license_key = var.mule_license_key
      }
    }
  ]

  #Uploading Parts
  ec2_launch_script_parts_rendered = [ for part in local.ec2_launch_script_parts : <<EOF
--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: ${part.content-type}
Mime-Version: 1.0

${templatefile(part.filepath, part.vars)}
EOF
]

  ec2_launch_cloud_init_gzip = base64gzip(templatefile("${path.module}/resources/cloud-init.tpl", {cloud_init_parts = local.ec2_launch_script_parts_rendered}))

}

data "aws_availability_zones" "available" { state = "available" }