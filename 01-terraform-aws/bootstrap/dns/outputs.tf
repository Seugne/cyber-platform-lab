output "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for cloudguardlab.fr"
  value       = aws_route53_zone.cloudguardlab.zone_id
}

output "name_servers" {
  description = "Authoritative Route 53 name servers for cloudguardlab.fr"
  value       = aws_route53_zone.cloudguardlab.name_servers
}
