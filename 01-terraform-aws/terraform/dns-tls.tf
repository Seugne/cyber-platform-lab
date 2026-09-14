# -----------------------------------------------------------------------------
# CloudGuard public DNS and TLS
#
# cloudguardlab.fr is registered externally and delegated to Route 53.
# Terraform manages:
# - ACM certificate for app.cloudguardlab.fr
# - ACM DNS validation
# - Route 53 alias from app.cloudguardlab.fr to the public ALB
# -----------------------------------------------------------------------------

locals {
  root_domain = "cloudguardlab.fr"
  app_domain  = "app.cloudguardlab.fr"
}

# The public hosted zone is managed by the persistent DNS bootstrap state.
data "aws_route53_zone" "cloudguardlab" {
  name         = local.root_domain
  private_zone = false
}

# -----------------------------------------------------------------------------
# ACM public certificate
# -----------------------------------------------------------------------------

resource "aws_acm_certificate" "cloudguard_app" {
  count = var.enable_alb ? 1 : 0

  domain_name       = local.app_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.project_name}-app-certificate"
    Role = "public-tls"
  }
}

# -----------------------------------------------------------------------------
# DNS validation record requested by ACM
# -----------------------------------------------------------------------------

resource "aws_route53_record" "acm_validation" {
  for_each = var.enable_alb ? {
    for dvo in aws_acm_certificate.cloudguard_app[0].domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id = data.aws_route53_zone.cloudguardlab.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60

  records = [
    each.value.record
  ]
}

resource "aws_acm_certificate_validation" "cloudguard_app" {
  count = var.enable_alb ? 1 : 0

  certificate_arn = aws_acm_certificate.cloudguard_app[0].arn

  validation_record_fqdns = [
    for record in aws_route53_record.acm_validation : record.fqdn
  ]
}

# -----------------------------------------------------------------------------
# Public application DNS record
#
# app.cloudguardlab.fr -> Application Load Balancer
# -----------------------------------------------------------------------------

resource "aws_route53_record" "app" {
  count = var.enable_alb ? 1 : 0

  zone_id = data.aws_route53_zone.cloudguardlab.zone_id
  name    = local.app_domain
  type    = "A"

  alias {
    name                   = aws_lb.application[0].dns_name
    zone_id                = aws_lb.application[0].zone_id
    evaluate_target_health = true
  }
}
