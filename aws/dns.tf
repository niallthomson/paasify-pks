resource "aws_route53_record" "pks_api_dns" {
  zone_id = module.pave.dns_zone_id
  name    = "api.pks.${module.pave.base_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.pks_api.dns_name
    zone_id                = aws_lb.pks_api.zone_id
    evaluate_target_health = true
  }
}