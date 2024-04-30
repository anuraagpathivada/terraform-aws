# Global

region = "ap-south-1"
env_type = "demo"

# VPC

vpc_name = "practice"
vpc_cidr = "10.148.0.0/16"
azs = ["ap-south-1a","ap-south-1b"]
private_subnets = ["10.148.1.0/24","10.148.2.0/24"]
public_subnets = ["10.148.3.0/24","10.148.4.0/24"]

# Elastic Beanstalk

beanstalkappname = "sample-demo-backend"
solution_stack_name = "64bit Amazon Linux 2023 v4.0.10 running Python 3.11"
instance_type = "t2.small"
app_version_label = "sample-demo-backend-version-x"

# Certificates

certificate_arn = "" # Use your certificate ARN that you want to use for SSL Termination

# Route 53

domain_name = "" # Use the domain name that you want to use 