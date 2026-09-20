output "github_actions_deploy_role_arn" {
  description = "IAM role ARN assumed by the protected GitHub production deployment workflow"
  value       = aws_iam_role.github_actions_deploy.arn
}

output "trusted_github_deployment_subject" {
  description = "GitHub OIDC subject allowed to assume the deployment role"
  value       = local.github_production_environment_sub
}
