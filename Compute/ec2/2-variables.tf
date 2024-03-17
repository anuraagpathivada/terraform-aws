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

variable "domain_name" {
  type = string
}