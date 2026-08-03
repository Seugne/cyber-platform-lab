# -----------------------------------------------------------------------------
# CloudGuard demonstration profile
#
# Temporary profile for validating EC2, SSM and private connectivity.
# Expensive application services remain disabled until explicitly required.
# -----------------------------------------------------------------------------

environment = "staging"

enable_nat_gateway         = false
enable_interface_endpoints = true
enable_compute             = true
enable_alb                 = false
enable_rds                 = false

enable_aws_config                 = false
enable_cloudtrail_cloudwatch_logs = true
cloudtrail_log_retention_days     = 7
