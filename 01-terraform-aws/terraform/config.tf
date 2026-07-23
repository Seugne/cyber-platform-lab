# -----------------------------------------------------------------------------
# AWS Config
#
# Records supported resource configuration changes and delivers configuration
# history and snapshots to the central audit bucket.
# -----------------------------------------------------------------------------

resource "aws_config_configuration_recorder" "cloudguard" {
  count = var.enable_aws_config ? 1 : 0

  name     = "${local.project_name}-configuration-recorder"
  role_arn = aws_iam_role.config[0].arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  recording_mode {
    recording_frequency = "CONTINUOUS"
  }
}

resource "aws_config_delivery_channel" "cloudguard" {
  count = var.enable_aws_config ? 1 : 0

  name           = "${local.project_name}-delivery-channel"
  s3_bucket_name = aws_s3_bucket.audit.id
  s3_key_prefix  = "config"

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }

  depends_on = [
    aws_config_configuration_recorder.cloudguard,
    aws_s3_bucket_policy.audit,
    aws_iam_role_policy.config_delivery
  ]
}

resource "aws_config_configuration_recorder_status" "cloudguard" {
  count = var.enable_aws_config ? 1 : 0

  name       = aws_config_configuration_recorder.cloudguard[0].name
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.cloudguard
  ]
}
