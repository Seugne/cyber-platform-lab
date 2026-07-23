# -----------------------------------------------------------------------------
# Account management-events trail
#
# Cost-control posture:
# - management events only
# - no S3/Lambda data events
# - one copy of read and write events
# - multi-Region visibility
# - log file validation enabled
# -----------------------------------------------------------------------------

resource "aws_cloudtrail" "management" {
  name                          = local.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.audit.id
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  enable_logging                = true

  cloud_watch_logs_group_arn = (
    var.enable_cloudtrail_cloudwatch_logs
    ? "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
    : null
  )

  cloud_watch_logs_role_arn = (
    var.enable_cloudtrail_cloudwatch_logs
    ? aws_iam_role.cloudtrail_cloudwatch[0].arn
    : null
  )

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  insight_selector {
    insight_type = "ApiCallRateInsight"
  }

  tags = {
    Name = local.cloudtrail_name
    Role = "account-audit"
  }

  depends_on = [
    aws_s3_bucket_policy.audit,
    aws_iam_role_policy.cloudtrail_cloudwatch
  ]
}
