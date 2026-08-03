# CloudGuard Environment Profiles

CloudGuard uses one Terraform codebase with two deployment profiles.

## Laboratory

The laboratory profile preserves the CloudGuard network, security, encryption,
audit and PostgreSQL foundations while disabling selected hourly-cost services.

```bash
terraform plan -var-file=environments/lab.tfvars
```

The laboratory profile disables:

- NAT Gateway
- EC2 compute layer
- Application Load Balancer
- SSM interface VPC endpoints
- AWS Config
- CloudTrail delivery to CloudWatch Logs

RDS PostgreSQL remains a core CloudGuard component.

## Production

The production profile enables the complete CloudGuard architecture.

```bash
terraform plan -var-file=environments/production.tfvars
```

Production includes NAT Gateway, private EC2 instances, interface endpoints,
Application Load Balancer, PostgreSQL RDS, AWS Config and CloudWatch integration.

Always inspect the Terraform execution plan and estimated AWS costs before apply.
