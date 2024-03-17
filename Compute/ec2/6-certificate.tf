# 3-acm-certificate.tf

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.domain_name}" 
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


# Certificate validation 
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_acm_certificate.cert.domain_validation_options : record.resource_record_name]
}