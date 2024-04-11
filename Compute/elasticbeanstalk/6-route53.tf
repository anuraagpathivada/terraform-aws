# Get Zone ID

data "aws_route53_zone" "selected" {
  name = var.domain_name
}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

#Map the LB to the Domain

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "samplewebapp-backend"
  type    = "A"
  alias {
    name                   = aws_elastic_beanstalk_environment.beanstalkappenv.cname
    zone_id                = data.aws_elastic_beanstalk_hosted_zone.current.id
    evaluate_target_health = true
  }
}

