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

# Elastic Beanstalk

variable "beanstalkappname" {
  type = string
}

variable "solution_stack_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "app_version_label" {
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