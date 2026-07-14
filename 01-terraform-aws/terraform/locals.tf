locals {
  project_name = "cloudguard"

  common_tags = {
    Project     = "CloudGuard"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "cyber-platform-lab"
    Owner       = "Alain-SEUGNE"
  }
}
