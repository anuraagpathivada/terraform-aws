# Global

variable "region" {
  type = string
}
variable "env_type" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "org_name" {
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