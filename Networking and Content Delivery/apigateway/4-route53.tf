data "aws_route53_zone" "selected" {
    name = var.domain_name
}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.app_name}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_api_gateway_domain_name.api_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_domain.regional_zone_id
    evaluate_target_health = true
  }
}