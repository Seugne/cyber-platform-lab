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
