# CloudGuard Environment Profiles

CloudGuard uses one Terraform codebase with different environment profiles.

## Laboratory

Low-cost profile for validating the networking, IAM, encryption and governance foundations.

```bash
terraform plan -var-file=environments/lab.tfvars
```

Main hourly-cost resources are disabled.

## Demonstration

Temporary profile for validating private EC2 instances and AWS Systems Manager connectivity.

```bash
terraform plan -var-file=environments/demo.tfvars
```

This profile enables EC2 and the SSM interface endpoints while leaving ALB and RDS disabled.

## Production

Complete CloudGuard architecture.

```bash
terraform plan -var-file=environments/production.tfvars
```

This profile enables NAT Gateway, interface endpoints, compute, ALB, RDS, AWS Config and CloudWatch integration.

Always inspect the Terraform plan and estimated AWS costs before applying an environment profile.
