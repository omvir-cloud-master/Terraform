variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr (the total pool of private IP addresses assigned to that cloud network)"
  default     = "10.0.0.0/16"
}


variable "pub_sub_cidr" {
  type        = list(string)
  description = "Public subnet cidr"
  default     = ["10.0.1.0/24", "10.0.16.0/24"]
}


variable "pub_sub_az" {
  type        = list(string)
  description = "Public subnet az"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_sub_cidr" {
  type        = list(string)
  description = "Private subnet cidr"
  default     = ["10.0.24.0/24", "10.0.48.0/24"]
}


variable "private_sub_az" {
  type        = list(string)
  description = "Private subnet az"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "db_sub_cidr" {
  description = "Database subnet cidr"
  type        = list(string)
  default     = ["10.0.64.0/24", "10.0.96.0/24"]
}

variable "db_sub_az" {
  description = "Database subnet AZs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "igw_name" {
  type        = string
  description = "internet gateway name"
  default     = "igw_tf"
}

# variable "rtb_name" {
#   type        = string
#   description = "internet route table  name"
#   default     = "rtb_tf"
# }