# GLobal

variable "region" {
  type = string
}
variable "env_type" {
  type = string
}

# VPC 

variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "azs" {
  type = list(any)
}
variable "private_subnets" {
  type = list(any)
}
variable "public_subnets" {
  type = list(any)
}


# EC2

variable "ec2_image" {
  type = string
}
variable "ec2_instance_type" {
  type = string
}
variable "bastionopenssh" {
  type = string
}
variable "git_username" {
  type = string
}
variable "git_password" {
  type = string
}

# Certificates

variable "certificate_arn" {
  type = string
}

# Route 53

variable "domain_name" {
  type = string
}

# IAM

variable "eks_user_for_access" {
  type = string
}
