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

resource "aws_kms_key" "cloudguard" {
  description = "Customer-managed KMS key for CloudGuard infrastructure encryption"

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
