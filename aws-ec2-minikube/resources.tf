# Create AWS Key Pair
resource "aws_key_pair" "minikube_key" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "minikube_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public.id

  security_groups = [ aws_security_group.ec2.id ]

  # Configure the primary disk (root volume) size
  root_block_device {
    volume_size           = 32         # Size in GB
    volume_type           = "gp3"      # Volume type (optional, default is gp2)
    delete_on_termination = true       # Optional, default is true
  }

  user_data = local.ec2_launch_cloud_init_gzip

  tags = {
    Name = "${var.prefix}-minikube-instance"
  }
}