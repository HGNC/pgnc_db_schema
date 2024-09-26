variable "region" {
  description = "AWS region"
}
variable "env" {
  description = "environment short name"
}
variable "availability_zones" {
  description = "availability zones for MIGs and instances"
}
variable "vpc_cidr" {
  description = "VPC CIDR"
}
variable "subnets" {
  description = "the subnet CIDRs to create the Subnets"
}
variable "private_key_path" {
  description = "path to the private key"
  type        = string
}
