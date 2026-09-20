# -----------------------------------------------------------------------------
# GitHub Actions deployment role
#
# This role is intentionally separate from the read-only Terraform plan role.
# Only workflows running in the protected GitHub Environment "production"
# may assume it.
# -----------------------------------------------------------------------------

locals {
  github_production_environment_sub = "repo:${local.github_repository}:environment:production"
}

data "aws_iam_policy_document" "github_actions_deploy_assume_role" {
  statement {
    sid     = "AllowCloudGuardProductionEnvironment"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.github_production_environment_sub]
    }
  }
}

resource "aws_iam_role" "github_actions_deploy" {
  name        = "cloudguard-github-actions-deploy"
  description = "Deployment role used by the protected CloudGuard production GitHub Environment"

  assume_role_policy = data.aws_iam_policy_document.github_actions_deploy_assume_role.json

  max_session_duration = 3600

  tags = {
    Name = "cloudguard-github-actions-deploy"
    Role = "terraform-deployment"
  }
}

# PowerUserAccess permits infrastructure deployment but does not grant
# unrestricted IAM administration.
resource "aws_iam_role_policy_attachment" "deploy_power_user" {
  role       = aws_iam_role.github_actions_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# -----------------------------------------------------------------------------
# Terraform backend write access
#
# Unlike the PLAN role, the DEPLOY role must be able to update the Terraform
# state after an apply/destroy.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "terraform_backend_deploy" {
  statement {
    sid = "AccessTerraformStateBucket"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${local.terraform_state_bucket}"
    ]
  }

  statement {
    sid = "ManageTerraformState"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.terraform_state_bucket}/${local.terraform_state_key}"
    ]
  }

  statement {
    sid = "ManageTerraformStateLock"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${local.terraform_state_bucket}/${local.terraform_state_key}.tflock"
    ]
  }

  statement {
    sid = "UseTerraformBackendKMSKey"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]

    resources = [
      local.backend_kms_key_arn
    ]
  }
}

resource "aws_iam_role_policy" "terraform_backend_deploy" {
  name   = "cloudguard-terraform-backend-deploy"
  role   = aws_iam_role.github_actions_deploy.id
  policy = data.aws_iam_policy_document.terraform_backend_deploy.json
}

# -----------------------------------------------------------------------------
# IAM permissions required by the CloudGuard Terraform stack
#
# PowerUserAccess deliberately excludes IAM administration. Terraform still
# needs to create and manage the CloudGuard EC2/RDS/service roles, policies,
# and instance profiles. Those permissions are restricted to cloudguard-*.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "cloudguard_deployment_iam" {
  statement {
    sid = "ManageCloudGuardRoles"

    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cloudguard-*"
    ]
  }

  statement {
    sid = "ManageCloudGuardPolicies"

    actions = [
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:ListPolicyVersions",
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/cloudguard-*"
    ]
  }

  statement {
    sid = "ManageCloudGuardInstanceProfiles"

    actions = [
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:GetInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:UntagInstanceProfile"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/cloudguard-*"
    ]
  }

  statement {
    sid = "ReadIAMForTerraform"

    actions = [
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicies",
      "iam:ListRoles",
      "iam:ListInstanceProfiles",
      "iam:ListInstanceProfilesForRole"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cloudguard_deployment_iam" {
  name   = "cloudguard-deployment-iam"
  role   = aws_iam_role.github_actions_deploy.id
  policy = data.aws_iam_policy_document.cloudguard_deployment_iam.json
}
