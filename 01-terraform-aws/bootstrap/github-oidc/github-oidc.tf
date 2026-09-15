data "aws_caller_identity" "current" {}

locals {
  github_repository = "Seugne/cyber-platform-lab"
  main_branch_sub   = "repo:${local.github_repository}:ref:refs/heads/main"

  terraform_state_bucket = "cloudguard-terraform-state-982081065479-eu-west-3"
  terraform_state_key    = "cloudguard/infrastructure/terraform.tfstate"

  backend_kms_key_arn = "arn:aws:kms:eu-west-3:982081065479:key/ab63d735-a6d6-4cee-8f43-1d173b0e396d"
}

# -----------------------------------------------------------------------------
# GitHub Actions OIDC identity provider
# -----------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name = "github-actions"
    Role = "federated-ci-identity"
  }
}

# -----------------------------------------------------------------------------
# GitHub Actions CI role
#
# Only workflow runs originating from the main branch of the CloudGuard
# repository can assume this role.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    sid     = "AllowCloudGuardMainBranch"
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
      values   = [local.main_branch_sub]
    }
  }
}

resource "aws_iam_role" "github_actions_plan" {
  name               = "cloudguard-github-actions-plan"
  description        = "Read-oriented role used by CloudGuard GitHub Actions Terraform CI"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  max_session_duration = 3600

  tags = {
    Name = "cloudguard-github-actions-plan"
    Role = "terraform-ci"
  }
}

# Terraform needs read access to AWS resources when generating a real plan.
resource "aws_iam_role_policy_attachment" "read_only" {
  role       = aws_iam_role.github_actions_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# -----------------------------------------------------------------------------
# Terraform remote-state access
#
# The CI role may read the production state and create/delete only the S3
# lockfile required by Terraform. It cannot modify the Terraform state itself.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "terraform_backend" {
  statement {
    sid = "ReadTerraformStateBucket"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${local.terraform_state_bucket}"
    ]
  }

  statement {
    sid = "ReadTerraformState"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
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
    sid = "UseBackendKMSKey"

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

resource "aws_iam_role_policy" "terraform_backend" {
  name   = "cloudguard-terraform-backend-access"
  role   = aws_iam_role.github_actions_plan.id
  policy = data.aws_iam_policy_document.terraform_backend.json
}
