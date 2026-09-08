provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
      Project     = "CloudGuard"
      Environment = "bootstrap"
      ManagedBy   = "Terraform"
      Repository  = "cyber-platform-lab"
      Purpose     = "Public DNS"
    }
  }
}
