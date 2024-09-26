variable "region" {
  description = "The name of the Amazon region"
  type        = string
  default     = "eu-west-2"
}

variable "availability_zones" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = ["eu-west-2a"]
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the RDS instance"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
}

variable "rds_admin_username" {
  description = "The master username for the RDS instance"
  type        = string
  sensitive   = true
}

variable "rds_admin_password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true
}
