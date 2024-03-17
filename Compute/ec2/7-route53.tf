data "aws_route53_zone" "selected" {
  name = var.domain_name
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "samplewebapp"
  type    = "A"

  alias {
    name                   = "${aws_lb.app_alb.dns_name}"
    zone_id                = "${aws_lb.app_alb.zone_id}"
    evaluate_target_health = true
  }
  depends_on = [aws_lb.app_alb]
}