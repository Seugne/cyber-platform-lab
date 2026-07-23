# -----------------------------------------------------------------------------
# CloudWatch Logs
#
# CloudTrail management events are retained here for short-term investigation
# and alerting. Long-term immutable-style retention remains in S3.
# -----------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cloudtrail" {
  count = var.enable_cloudtrail_cloudwatch_logs ? 1 : 0

  name              = "/aws/cloudguard/cloudtrail"
  retention_in_days = var.cloudtrail_log_retention_days

  tags = {
    Name      = "${local.project_name}-cloudtrail-log-group"
    Role      = "security-monitoring"
    DataClass = "audit-logs"
  }
}

# -----------------------------------------------------------------------------
# CloudTrail role for CloudWatch Logs delivery
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "cloudtrail_cloudwatch_assume_role" {
  statement {
    sid     = "AllowCloudTrailToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [data.aws_caller_identity.governance.account_id]
    }
  }
}

resource "aws_iam_role" "cloudtrail_cloudwatch" {
  count = var.enable_cloudtrail_cloudwatch_logs ? 1 : 0

  name               = "${local.project_name}-role-cloudtrail-cloudwatch"
  description        = "Allows CloudTrail to publish management events to CloudWatch Logs"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_cloudwatch_assume_role.json

  tags = {
    Name = "${local.project_name}-role-cloudtrail-cloudwatch"
    Role = "security-logging"
  }
}

data "aws_iam_policy_document" "cloudtrail_cloudwatch" {
  count = var.enable_cloudtrail_cloudwatch_logs ? 1 : 0

  statement {
    sid    = "AllowCloudTrailLogStreamCreation"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudtrail[0].arn}:log-stream:${data.aws_caller_identity.governance.account_id}_CloudTrail_${data.aws_region.governance.region}*"
    ]
  }

  statement {
    sid    = "AllowCloudTrailLogDelivery"
    effect = "Allow"

    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudtrail[0].arn}:log-stream:${data.aws_caller_identity.governance.account_id}_CloudTrail_${data.aws_region.governance.region}*"
    ]
  }
}

resource "aws_iam_role_policy" "cloudtrail_cloudwatch" {
  count = var.enable_cloudtrail_cloudwatch_logs ? 1 : 0

  name   = "${local.project_name}-cloudtrail-cloudwatch-policy"
  role   = aws_iam_role.cloudtrail_cloudwatch[0].id
  policy = data.aws_iam_policy_document.cloudtrail_cloudwatch[0].json
}
