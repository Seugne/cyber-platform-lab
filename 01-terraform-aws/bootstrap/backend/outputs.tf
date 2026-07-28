output "state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform remote state."
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket storing Terraform remote state."
  value       = aws_s3_bucket.terraform_state.arn
}

output "backend_configuration" {
  description = "Backend settings to use in the main Terraform project."
  value = {
    bucket       = aws_s3_bucket.terraform_state.id
    key          = "cloudguard/infrastructure/terraform.tfstate"
    region       = var.aws_region
    encrypt      = true
    kms_key_id   = aws_kms_key.terraform_state.arn
    use_lockfile = true
  }
}

output "state_kms_key_arn" {
  description = "ARN of the KMS key encrypting the Terraform state."
  value       = aws_kms_key.terraform_state.arn
}

output "state_kms_alias" {
  description = "Alias of the KMS key encrypting the Terraform state."
  value       = aws_kms_alias.terraform_state.name
}
