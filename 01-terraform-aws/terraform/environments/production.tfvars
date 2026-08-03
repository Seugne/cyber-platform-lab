# -----------------------------------------------------------------------------
# CloudGuard production profile
#
# Complete architecture with private workloads, centralized governance,
# monitoring and managed database services.
# -----------------------------------------------------------------------------

environment = "production"

enable_nat_gateway         = true
enable_interface_endpoints = true
enable_compute             = true
enable_alb                 = true
enable_rds                 = true

enable_aws_config                 = true
enable_cloudtrail_cloudwatch_logs = true
cloudtrail_log_retention_days     = 90
