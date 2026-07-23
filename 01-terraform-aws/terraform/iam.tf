# -----------------------------------------------------------------------------
# CloudGuard IAM
#
# Two separate EC2 identities are created:
# - Application instance role
# - Administration instance role
#
# No long-lived AWS access keys are stored on the instances.
# EC2 obtains temporary credentials through the Instance Metadata Service.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# EC2 trust policy
#
# This policy answers:
# "Who is allowed to assume these roles?"
#
# Only the EC2 service is trusted.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid     = "AllowEC2ServiceToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# -----------------------------------------------------------------------------
# Application EC2 role
# -----------------------------------------------------------------------------

resource "aws_iam_role" "app_ec2" {
  name               = "${local.project_name}-role-app-ec2"
  description        = "Least-privilege IAM role used by the CloudGuard application instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${local.project_name}-role-app-ec2"
    Role = "application"
  }
}

resource "aws_iam_instance_profile" "app_ec2" {
  name = "${local.project_name}-instance-profile-app"
  role = aws_iam_role.app_ec2.name

  tags = {
    Name = "${local.project_name}-instance-profile-app"
    Role = "application"
  }
}

# -----------------------------------------------------------------------------
# Administration EC2 role
# -----------------------------------------------------------------------------

resource "aws_iam_role" "admin_ssm" {
  name               = "${local.project_name}-role-admin-ssm"
  description        = "Least-privilege IAM role used by the private SSM administration instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${local.project_name}-role-admin-ssm"
    Role = "administration"
  }
}

resource "aws_iam_instance_profile" "admin_ssm" {
  name = "${local.project_name}-instance-profile-admin"
  role = aws_iam_role.admin_ssm.name

  tags = {
    Name = "${local.project_name}-instance-profile-admin"
    Role = "administration"
  }
}

# -----------------------------------------------------------------------------
# AWS-managed Systems Manager policy
#
# AmazonSSMManagedInstanceCore permits the SSM Agent to communicate with:
# - Systems Manager
# - ssmmessages
# - ec2messages
#
# It does not grant administrator access to the whole AWS account.
# -----------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "app_ssm_core" {
  role       = aws_iam_role.app_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "admin_ssm_core" {
  role       = aws_iam_role.admin_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# -----------------------------------------------------------------------------
# CloudWatch Agent policy
#
# Allows instances to publish operating-system and application telemetry.
# The CloudWatch Agent itself will be configured in a later observability layer.
# -----------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "app_cloudwatch_agent" {
  role       = aws_iam_role.app_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "admin_cloudwatch_agent" {
  role       = aws_iam_role.admin_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# -----------------------------------------------------------------------------
# Amazon RDS Enhanced Monitoring role
#
# This role is assumed by the RDS monitoring service, not by an EC2 instance.
# It allows RDS to publish operating-system metrics to CloudWatch Logs.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "rds_monitoring_assume_role" {
  statement {
    sid     = "AllowRDSMonitoringServiceToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_monitoring" {
  name               = "${local.project_name}-role-rds-monitoring"
  description        = "Allows Amazon RDS Enhanced Monitoring to publish operating-system metrics"
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_assume_role.json

  tags = {
    Name = "${local.project_name}-role-rds-monitoring"
    Role = "database-monitoring"
  }
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# -----------------------------------------------------------------------------
# AWS Config recorder role
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "config_assume_role" {
  statement {
    sid     = "AllowConfigToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [data.aws_caller_identity.governance.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"
      values = [
        "arn:${data.aws_partition.governance.partition}:config:${data.aws_region.governance.region}:${data.aws_caller_identity.governance.account_id}:*"
      ]
    }
  }
}

resource "aws_iam_role" "config" {
  count = var.enable_aws_config ? 1 : 0

  name               = "${local.project_name}-role-config-recorder"
  description        = "Allows AWS Config to discover and record supported AWS resource configurations"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role.json

  tags = {
    Name = "${local.project_name}-role-config-recorder"
    Role = "governance"
  }
}

resource "aws_iam_role_policy_attachment" "config_managed" {
  count = var.enable_aws_config ? 1 : 0

  role       = aws_iam_role.config[0].name
  policy_arn = "arn:${data.aws_partition.governance.partition}:iam::aws:policy/service-role/AWS_ConfigRole"
}

data "aws_iam_policy_document" "config_delivery" {
  count = var.enable_aws_config ? 1 : 0

  statement {
    sid    = "AllowAuditBucketDiscovery"
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.audit.arn
    ]
  }

  statement {
    sid    = "AllowConfigurationDelivery"
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.audit.arn}/config/AWSLogs/${data.aws_caller_identity.governance.account_id}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_iam_role_policy" "config_delivery" {
  count = var.enable_aws_config ? 1 : 0

  name   = "${local.project_name}-config-delivery-policy"
  role   = aws_iam_role.config[0].id
  policy = data.aws_iam_policy_document.config_delivery[0].json
}
