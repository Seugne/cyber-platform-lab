output "github_oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_plan_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions for Terraform CI plans"
  value       = aws_iam_role.github_actions_plan.arn
}

output "trusted_github_subject" {
  description = "GitHub OIDC subject allowed to assume the CI role"
  value       = local.main_branch_sub
}
