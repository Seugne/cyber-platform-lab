# -----------------------------------------------------------------------------
# Central audit bucket
#
# Receives:
# - AWS CloudTrail log files
# - AWS Config snapshots and configuration history
#
# Security posture:
# - private bucket
# - all public access blocked
# - versioning enabled
# - server-side encryption enabled
# - TLS required
# - lifecycle expiration configured
# -----------------------------------------------------------------------------

locals {
  audit_bucket_name = lower(
    "${local.project_name}-audit-${data.aws_caller_identity.governance.account_id}-${data.aws_region.governance.region}"
  )

  cloudtrail_name = "${local.project_name}-management-trail"
}

resource "aws_s3_bucket" "audit" {
  bucket        = local.audit_bucket_name
  force_destroy = false

  tags = {
    Name            = local.audit_bucket_name
    Role            = "central-audit-logging"
    DataClass       = "security-logs"
    Confidentiality = "restricted"
  }
}

resource "aws_s3_bucket_public_access_block" "audit" {
  bucket = aws_s3_bucket.audit.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "audit" {
  bucket = aws_s3_bucket.audit.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "audit" {
  bucket = aws_s3_bucket.audit.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit" {
  bucket = aws_s3_bucket.audit.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled = false
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "audit" {
  bucket = aws_s3_bucket.audit.id

  depends_on = [
    aws_s3_bucket_versioning.audit
  ]

  rule {
    id     = "expire-audit-logs"
    status = "Enabled"

    filter {}

    expiration {
      days = var.audit_log_expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.audit_noncurrent_version_expiration_days
    }
  }
}

# -----------------------------------------------------------------------------
# Audit bucket policy
#
# CloudTrail requires:
# - s3:GetBucketAcl
# - s3:PutObject
#
# AWS Config requires:
# - s3:GetBucketAcl
# - s3:ListBucket
# - s3:PutObject
#
# Every non-service access request must use HTTPS.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "audit_bucket" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.audit.arn,
      "${aws_s3_bucket.audit.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "AllowCloudTrailBucketAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = [
      aws_s3_bucket.audit.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:${data.aws_partition.governance.partition}:cloudtrail:${data.aws_region.governance.region}:${data.aws_caller_identity.governance.account_id}:trail/${local.cloudtrail_name}"
      ]
    }
  }

  statement {
    sid    = "AllowCloudTrailLogDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.audit.arn}/cloudtrail/AWSLogs/${data.aws_caller_identity.governance.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:${data.aws_partition.governance.partition}:cloudtrail:${data.aws_region.governance.region}:${data.aws_caller_identity.governance.account_id}:trail/${local.cloudtrail_name}"
      ]
    }
  }

  statement {
    sid    = "AllowConfigBucketDiscovery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.audit.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [data.aws_caller_identity.governance.account_id]
    }
  }

  statement {
    sid    = "AllowConfigLogDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.audit.arn}/config/AWSLogs/${data.aws_caller_identity.governance.account_id}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [data.aws_caller_identity.governance.account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "audit" {
  bucket = aws_s3_bucket.audit.id
  policy = data.aws_iam_policy_document.audit_bucket.json

  depends_on = [
    aws_s3_bucket_public_access_block.audit,
    aws_s3_bucket_ownership_controls.audit
  ]
}
