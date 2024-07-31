# --- VPC ---

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.prefix}-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = local.azs_names[0]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 10)
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.prefix}-public-${local.azs_names[0]}" }
}

# --- Internet Gateway ---

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.prefix}-igw" }
}

resource "aws_eip" "main" {
  depends_on = [aws_internet_gateway.main]
  tags       = { Name = "${var.prefix}-eip-${local.azs_names[0]}" }
}

# --- Public Route Table ---

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.prefix}-rt-public" }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# --- EC2 SG ---

resource "aws_security_group" "ec2" {
  name_prefix = "${var.prefix}-http-sg-"
  description = "Allow SSH traffic from public"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [22]
    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

