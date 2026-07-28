# Terraform Backend Bootstrap

This directory provisions the secure Amazon S3 backend used to store the CloudGuard Terraform state.

## Security controls

- S3 Block Public Access
- Bucket owner enforced
- Server-side encryption with Amazon S3 managed keys
- Bucket versioning
- TLS-only bucket policy
- Old state-version retention
- Terraform deletion protection
- Native S3 state locking in the main configuration

## Bootstrap workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

The bootstrap configuration initially uses local state because the remote S3 backend does not exist before its first deployment.
