# Create S3 Bucket
resource "aws_s3_bucket" "default" {
  bucket = var.beanstalkappname
  force_destroy = true

  tags = {
    Name        = "Test Bucket for Holding Elasticbeanstalk application"
    "Terraform" = "true" 
  }
}

resource "aws_s3_object" "default" {
  bucket = aws_s3_bucket.default.id
  key    = "flask-eb.zip"
  source = "flask-eb.zip"
}
