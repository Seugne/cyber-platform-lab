resource "aws_route53_zone" "cloudguardlab" {
  name    = "cloudguardlab.fr"
  comment = "Authoritative public DNS zone for CloudGuard"
}
