# GLobal 

variable "region" {
  type = string
}
variable "acm_certificate" {
  type = string
}
variable "domain_name" {
  type = string
}
variable "app_name" {
  type = string
}

# Api Gateway

variable "resource_mapping_uri" {
  type = string
}