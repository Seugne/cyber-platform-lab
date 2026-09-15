# -----------------------------------------------------------------------------
# CloudGuard KMS
#
# Customer-managed symmetric encryption key used by CloudGuard resources.
#
# Initial consumers:
# - EC2 root EBS volumes
#
# Future consumers:
# - RDS
# - S3
# - CloudWatch Logs
# - CloudTrail
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "cloudguard_kms" {
  # Preserve normal account/IAM administration of the key.
  statement {
    sid    = "EnableAccountIAMPermissions"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:${data.aws_partition.governance.partition}:iam::${data.aws_caller_identity.governance.account_id}:root"
      ]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  # CloudTrail needs a data key to encrypt log and digest files.
  statement {
    sid    = "AllowCloudTrailEncryptLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "kms:GenerateDataKey*"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:${data.aws_partition.governance.partition}:cloudtrail:${data.aws_region.governance.region}:${data.aws_caller_identity.governance.account_id}:trail/${local.cloudtrail_name}"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:${data.aws_partition.governance.partition}:cloudtrail:*:${data.aws_caller_identity.governance.account_id}:trail/*"
      ]
    }
  }

  statement {
    sid    = "AllowCloudTrailDescribeKey"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["kms:DescribeKey"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:${data.aws_partition.governance.partition}:cloudtrail:${data.aws_region.governance.region}:${data.aws_caller_identity.governance.account_id}:trail/${local.cloudtrail_name}"
      ]
    }
  }

  # AWS Config uses the CMK when writing configuration history/snapshots.
  statement {
    sid    = "AllowAWSConfigUseKey"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = ["*"]

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

resource "aws_kms_key" "cloudguard" {
  description = "Customer-managed KMS key for CloudGuard infrastructure encryption"
  policy      = data.aws_iam_policy_document.cloudguard_kms.json

  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  enable_key_rotation     = true
  deletion_window_in_days = 30

  tags = {
    Name    = "${local.project_name}-kms-key"
    Purpose = "infrastructure-encryption"
  }
}

resource "aws_kms_alias" "cloudguard" {
  name          = "alias/${local.project_name}"
  target_key_id = aws_kms_key.cloudguard.key_id
}
