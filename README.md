# Runtime Fabrics Formation - Terraform

## Overview

This Terraform script automates the deployment of a MuleSoft Runtime Fabric environment. It comprises two primary modules:

1. **Anypoint Fabrics Module (`anypoint_fabrics`)**: Provisions a Runtime Fabrics instance on the Anypoint Platform. This module should be executed first.
2. **Minikube Module (`minikube`)**: Creates a virtual machine on AWS EC2, installs Minikube on it, and subsequently installs the Runtime Fabric on Minikube. This module is dependent on the successful execution of the `anypoint_fabrics` module.

## Prerequisites

Before using this Terraform script, ensure you have the following:

- Terraform installed on your machine.
- AWS CLI configured with appropriate access to create and manage EC2 instances.
- Anypoint Platform credentials with permissions to create Runtime Fabrics instances.
- A valid MuleSoft Runtime Fabrics license key.

## Usage

### Step 1: Configure the Variables

The script uses several variables that must be set in the root module or via Terraform variables files (`.tfvars`). These variables configure the behavior of the modules and the infrastructure they deploy.

### Variable Descriptions

| **Variable Name**          | **Type** | **Default Value**                               | **Description**                                                                                      |
|----------------------------|----------|-------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **Root Module Variables**   |          |                                                 |                                                                                                      |
| `prefix`                   | String   | None                                            | The prefix name used for naming resources.                                                           |
| `anypoint_cplane`          | String   | `"us"`                                          | Anypoint control plane region.                                                                       |
| `anypoint_client_id`       | String   | None                                            | The client ID of the Anypoint user.                                                                  |
| `anypoint_client_secret`   | String   | None                                            | The client secret of the Anypoint user.                                                              |
| `anypoint_org_id`          | String   | None                                            | The Anypoint root organization ID.                                                                   |
| `anypoint_env_id`          | String   | `"7074fcdd-9b23-4ab3-97c8-5db5f4adf17d"`        | The Anypoint environment ID.                                                                         |
| `mule_license_key`         | String   | None                                            | MuleSoft Runtime Fabrics license key in base64.                                                      |
| `aws_profile`              | String   | None                                            | AWS profile name for CLI configuration.                                                              |
| `aws_public_key`           | String   | None                                            | The public key to be used for the EC2 instance key pair.                                             |
| `aws_instance_type`        | String   | `"t3.medium"`                                   | AWS EC2 instance type.                                                                               |
| `aws_ami_id`               | String   | `"ami-0c6d91e4a58c413a9"`                       | AWS AMI ID for the EC2 instance (default: Ubuntu).                                                   |
| `aws_region`               | String   | `"eu-west-1"`                                   | AWS region to deploy the infrastructure.                                                             |
| **Anypoint Fabrics Module** |          |                                                 |                                                                                                      |
| `prefix`                   | String   | None                                            | The prefix name used for naming resources.                                                           |
| `cplane`                   | String   | `"us"`                                          | Anypoint control plane region.                                                                       |
| `org_id`                   | String   | None                                            | The Anypoint organization ID.                                                                        |
| `region`                   | String   | `"us-east-1"`                                   | Anypoint region.                                                                                     |
| `vendor`                   | String   | `"eks"`                                         | The runtime fabrics vendor.                                                                          |
| `client_id`                | String   | None                                            | The client ID of the Anypoint user.                                                                  |
| `client_secret`            | String   | None                                            | The client secret of the Anypoint user.                                                              |
| **Minikube Module**         |          |                                                 |                                                                                                      |
| `prefix`                   | String   | None                                            | The prefix name used for naming resources.                                                           |
| `region`                   | String   | `"us-east-1"`                                   | AWS region to launch the instance.                                                                   |
| `profile`                  | String   | None                                            | AWS profile name for CLI configuration.                                                              |
| `ami_id`                   | String   | `"ami-0c6d91e4a58c413a9"`                       | AMI ID to use for the instance (default: Ubuntu).                                                    |
| `instance_type`            | String   | `"t2.micro"`                                    | EC2 instance type.                                                                                   |
| `cidr_block`               | String   | `"10.10.0.0/20"`                                | CIDR block for the network.                                                                          |
| `key_name`                 | String   | None                                            | Key name for the EC2 instance.                                                                       |
| `public_key`               | String   | None                                            | The public key to be used for the EC2 key pair.                                                      |
| `kube_version`             | String   | `"1.27.4"`                                      | Kubernetes version for Minikube.                                                                     |
| `cluster_nodes`            | Number   | `2`                                             | Number of cluster nodes in Minikube.                                                                 |
| `rtf_version`              | String   | `"2.5.0"`                                       | Runtime Fabrics version to install on the Kubernetes cluster.                                        |
| `docker_registry`          | String   | None                                            | Docker registry provided by Anypoint Platform.                                                       |
| `docker_username`          | String   | None                                            | Docker username generated by Anypoint Platform upon RTF instance creation.                           |
| `docker_password`          | String   | None                                            | Docker password generated by Anypoint Platform upon RTF instance creation.                           |
| `activation_data`          | String   | None                                            | Activation data for the setup generated by Anypoint Platform upon RTF instance creation.             |
| `mule_license_key`         | String   | None                                            | MuleSoft Runtime Fabrics license key in base64.                                                      |

### Step 2: Initialize Terraform

```bash
terraform init
```

This command initializes the Terraform environment, downloads necessary providers, and sets up the working directory.

### Step 3: Plan the Infrastructure

```bash
terraform plan
```

This command creates an execution plan that shows what actions Terraform will take to deploy the infrastructure. Review the plan carefully.

### Step 4: Apply the Infrastructure

```bash
terraform apply
```

This command applies the changes required to reach the desired state of the infrastructure. You will be prompted to confirm the action.

### Step 5: Destroy the Infrastructure (Optional)

If you need to destroy the infrastructure, use the following command:

```bash
terraform destroy
```

This command will remove all resources that were created by the `terraform apply` command.

## Dependencies

- **Anypoint Platform**: Required for creating the Runtime Fabrics instance.
- **AWS**: Required for deploying the EC2 instance and Minikube.

## License

This script is provided "as-is" without warranty of any kind. The user assumes all responsibility for use.

---

By following the above instructions, you should be able to deploy a Runtime Fabric environment using Terraform efficiently. If you encounter any issues, please consult the [Terraform documentation](https://www.terraform.io/docs/index.html) or your infrastructure administrator.
