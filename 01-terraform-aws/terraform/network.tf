# -----------------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------------

resource "aws_vpc" "cloudguard" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.project_name}-vpc"
  }
}

# Harden the default Security Group.
# Explicit application Security Groups will be created in a later layer.
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.cloudguard.id

  ingress = []
  egress  = []

  tags = {
    Name = "${local.project_name}-sg-default-deny"
  }
}

# -----------------------------------------------------------------------------
# Internet connectivity
# -----------------------------------------------------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.cloudguard.id

  tags = {
    Name = "${local.project_name}-igw"
  }
}

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "${local.project_name}-eip-nat-a"
  }

  depends_on = [aws_internet_gateway.main]
}

# -----------------------------------------------------------------------------
# Public subnets
# -----------------------------------------------------------------------------

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.cloudguard.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.project_name}-subnet-public-${count.index == 0 ? "a" : "b"}"
    Tier = "public"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${local.project_name}-nat-gw-a"
  }

  depends_on = [aws_internet_gateway.main]
}

# -----------------------------------------------------------------------------
# Private subnets
# -----------------------------------------------------------------------------

resource "aws_subnet" "private" {
  count = 2

  vpc_id            = aws_vpc.cloudguard.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "${local.project_name}-subnet-private-${count.index == 0 ? "a" : "b"}"
    Tier = "private"
  }
}

# -----------------------------------------------------------------------------
# Public routing
# -----------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudguard.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${local.project_name}-rt-public"
  }
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------------------------------------
# Private routing
#
# Lab design: both private subnets use NAT Gateway A.
# Production HA variant: deploy one NAT Gateway per Availability Zone.
# -----------------------------------------------------------------------------

resource "aws_route_table" "private" {
  count = 2

  vpc_id = aws_vpc.cloudguard.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "${local.project_name}-rt-private-${count.index == 0 ? "a" : "b"}"
  }
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
