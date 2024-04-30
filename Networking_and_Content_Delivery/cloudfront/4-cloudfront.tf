# 4-cloudfront.tf

resource "aws_cloudfront_distribution" "s3_distribution" {

  aliases = ["${var.bucket_name}.${var.domain_name}"]
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.webapp.bucket_regional_domain_name
    origin_id   = "PracticeS3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_control.oac.id
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "PracticeS3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  tags = {
    Name        = "${var.bucket_name}"
    "Terraform" = "true" 
  }
}


resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.bucket_name}"
  description                       = "${var.bucket_name}-for secure access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}