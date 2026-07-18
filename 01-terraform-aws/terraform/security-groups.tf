# -----------------------------------------------------------------------------
# CloudGuard Security Groups
#
# Communication model:
# Internet -> ALB:          HTTPS 443
# ALB -> Application:       TCP 8080
# Application -> RDS:       PostgreSQL 5432
# App/Admin -> AWS APIs:    HTTPS 443
#
# No inbound SSH rule is created. Administration uses AWS Systems Manager.
# -----------------------------------------------------------------------------

locals {
  application_port = 8080
  database_port    = 5432
  https_port       = 443
}

# -----------------------------------------------------------------------------
# ALB Security Group
# -----------------------------------------------------------------------------

resource "aws_security_group" "alb" {
  name        = "${local.project_name}-sg-alb"
  description = "Controls inbound HTTPS access to the public ALB"
  vpc_id      = aws_vpc.cloudguard.id

  tags = {
    Name = "${local.project_name}-sg-alb"
    Role = "load-balancer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_ipv4" {
  security_group_id = aws_security_group.alb.id

  description = "Allow public HTTPS traffic to the ALB"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = local.https_port
  to_port     = local.https_port
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id = aws_security_group.alb.id

  description                  = "Forward application traffic from ALB to EC2"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = local.application_port
  to_port                      = local.application_port
  ip_protocol                  = "tcp"
}

# -----------------------------------------------------------------------------
# Application Security Group
# -----------------------------------------------------------------------------

resource "aws_security_group" "app" {
  name        = "${local.project_name}-sg-app"
  description = "Controls traffic to and from the private application instance"
  vpc_id      = aws_vpc.cloudguard.id

  tags = {
    Name = "${local.project_name}-sg-app"
    Role = "application"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id = aws_security_group.app.id

  description                  = "Allow application traffic only from the ALB"
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = local.application_port
  to_port                      = local.application_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_to_rds" {
  security_group_id = aws_security_group.app.id

  description                  = "Allow PostgreSQL traffic from application to RDS"
  referenced_security_group_id = aws_security_group.rds.id
  from_port                    = local.database_port
  to_port                      = local.database_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_https_outbound" {
  security_group_id = aws_security_group.app.id

  description = "Allow HTTPS access to AWS APIs and approved package repositories"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = local.https_port
  to_port     = local.https_port
  ip_protocol = "tcp"
}

# -----------------------------------------------------------------------------
# RDS Security Group
# -----------------------------------------------------------------------------

resource "aws_security_group" "rds" {
  name        = "${local.project_name}-sg-rds"
  description = "Restricts PostgreSQL access to the application tier"
  vpc_id      = aws_vpc.cloudguard.id

  tags = {
    Name = "${local.project_name}-sg-rds"
    Role = "database"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_app" {
  security_group_id = aws_security_group.rds.id

  description                  = "Allow PostgreSQL only from the application tier"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = local.database_port
  to_port                      = local.database_port
  ip_protocol                  = "tcp"
}

# RDS initiates no application network connections.
# Stateful return traffic is automatically permitted by the Security Group.

# -----------------------------------------------------------------------------
# Private Administration Security Group
# -----------------------------------------------------------------------------

resource "aws_security_group" "admin" {
  name        = "${local.project_name}-sg-admin"
  description = "Controls the private SSM-managed administration instance"
  vpc_id      = aws_vpc.cloudguard.id

  tags = {
    Name = "${local.project_name}-sg-admin"
    Role = "administration"
  }
}

# No ingress rule:
# Session Manager connections are initiated outbound by the SSM Agent.

resource "aws_vpc_security_group_egress_rule" "admin_https_outbound" {
  security_group_id = aws_security_group.admin.id

  description = "Allow HTTPS access to Systems Manager and AWS APIs"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = local.https_port
  to_port     = local.https_port
  ip_protocol = "tcp"
}

# -----------------------------------------------------------------------------
# Interface VPC Endpoint Security Group
# -----------------------------------------------------------------------------

resource "aws_security_group" "vpc_endpoints" {
  name        = "${local.project_name}-sg-vpc-endpoints"
  description = "Controls HTTPS access to CloudGuard interface VPC endpoints"
  vpc_id      = aws_vpc.cloudguard.id

  tags = {
    Name = "${local.project_name}-sg-vpc-endpoints"
    Role = "vpc-endpoints"
  }
}

resource "aws_vpc_security_group_ingress_rule" "endpoints_from_app" {
  security_group_id = aws_security_group.vpc_endpoints.id

  description                  = "Allow HTTPS from the application instance"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = local.https_port
  to_port                      = local.https_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "endpoints_from_admin" {
  security_group_id = aws_security_group.vpc_endpoints.id

  description                  = "Allow HTTPS from the administration instance"
  referenced_security_group_id = aws_security_group.admin.id
  from_port                    = local.https_port
  to_port                      = local.https_port
  ip_protocol                  = "tcp"
}
