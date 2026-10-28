
variable "project_name" {
  description = "Name prefix for the cloud security project"
  type        = string
  default     = "secure-three-tier"
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}
