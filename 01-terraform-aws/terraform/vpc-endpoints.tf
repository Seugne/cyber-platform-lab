# -----------------------------------------------------------------------------
# VPC Endpoints
#
# Gateway endpoint:
# - Amazon S3
#
# Interface endpoints:
# - AWS Systems Manager
# - Systems Manager messages
# - EC2 messages
#
# Private DNS allows applications to use standard AWS service hostnames while
# the traffic resolves to private endpoint IP addresses inside the VPC.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Amazon S3 Gateway Endpoint
# -----------------------------------------------------------------------------

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.cloudguard.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = aws_route_table.private[*].id

  tags = {
    Name = "${local.project_name}-vpce-s3"
    Type = "gateway"
  }
}

# -----------------------------------------------------------------------------
# AWS Systems Manager Interface Endpoint
# -----------------------------------------------------------------------------

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.cloudguard.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints.id]

  tags = {
    Name = "${local.project_name}-vpce-ssm"
    Type = "interface"
  }
}

# -----------------------------------------------------------------------------
# Systems Manager secure message channel
# -----------------------------------------------------------------------------

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.cloudguard.id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints.id]

  tags = {
    Name = "${local.project_name}-vpce-ssmmessages"
    Type = "interface"
  }
}

# -----------------------------------------------------------------------------
# EC2 message delivery endpoint
#
# Retained for compatibility with SSM Agent versions and regional service
# behavior. Modern SSM Agent versions prefer ssmmessages when available.
# -----------------------------------------------------------------------------

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.cloudguard.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints.id]

  tags = {
    Name = "${local.project_name}-vpce-ec2messages"
    Type = "interface"
  }
}
