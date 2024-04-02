# Create S3 Bucket
resource "aws_s3_bucket" "webapp" {
  bucket = "${var.bucket_name}.${var.domain_name}"
  force_destroy = true

  tags = {
    Name        = "Test Bucket for Cloudfront"
    "Terraform" = "true" 
  }
}

resource "aws_s3_bucket_ownership_controls" "webapp" {
  bucket = aws_s3_bucket.webapp.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "webapp" {
  depends_on = [aws_s3_bucket_ownership_controls.webapp]

  bucket = aws_s3_bucket.webapp.id
  acl    = "private"
}


# Enable versioning for files in the bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.webapp.id
  versioning_configuration {
    status = "Enabled"
  }
}

# s3-bucket-policy.tf

resource "aws_s3_bucket_policy" "webapp" {
  bucket = aws_s3_bucket.webapp.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai.id}"
      },
      Action   = "s3:GetObject",
      Resource = "arn:aws:s3:::${aws_s3_bucket.webapp.id}/*"
    }]
  })
}