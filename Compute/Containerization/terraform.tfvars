# Global

region = "ap-south-1"
env_type = "demo"

# VPC

vpc_name = "practice"
vpc_cidr = "10.148.0.0/16"
azs = ["ap-south-1a","ap-south-1b"]
private_subnets = ["10.148.1.0/24","10.148.2.0/24"]
public_subnets = ["10.148.3.0/24","10.148.4.0/24"]

# EC2

ec2_image = "ami-026255a2746f88074" #(amazon-linux2)
ec2_instance_type = "t2.micro"
bastionopenssh = "bastionopenssh.pem"
git_username = "anuraagpathivada"
git_password = ""

# Certificates

certificate_arn = ""

# Route 53

domain_name = "a2suite.co.uk"

# EKS

eks_user_for_access = "Anuraag"