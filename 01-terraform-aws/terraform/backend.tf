terraform {
  backend "s3" {
    bucket       = "cloudguard-terraform-state-982081065479-eu-west-3"
    key          = "cloudguard/infrastructure/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    kms_key_id   = "arn:aws:kms:eu-west-3:982081065479:key/ab63d735-a6d6-4cee-8f43-1d173b0e396d"
    use_lockfile = true
  }
}
