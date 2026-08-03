# -----------------------------------------------------------------------------
# CloudGuard laboratory profile
#
# Purpose:
# - validate networking, IAM, encryption and governance foundations
# - minimize recurring AWS costs
# - activate expensive components only during focused demonstrations
# -----------------------------------------------------------------------------

environment = "lab"

enable_nat_gateway         = false
enable_interface_endpoints = false
enable_compute             = false
enable_alb                 = false

enable_aws_config                 = false
enable_cloudtrail_cloudwatch_logs = false
cloudtrail_log_retention_days     = 7
