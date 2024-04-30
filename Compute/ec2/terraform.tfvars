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
bastionopenssh = "bastionopenssh.pem" # create your own rsa public and private key pair and then save the pem file in the same directory
git_username = "anuraagpathivada"
git_password = ""

# Certificates

certificate_arn = "" # Use your certificate ARN that you want to use for SSL Termination

# Route 53

domain_name = "" # Use the domain name that you want to use 