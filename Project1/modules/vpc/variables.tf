variable "vpc_cidr" {
  type        = string
  description = "vpc cidr (the total pool of private IP addresses assigned to that cloud network)"
  default     = "10.0.0.0/16"
}


variable "vpc_name" {
  type        = string
  description = "vpc name"
  default     = "dev_vpc_tf"
}


variable "pub_sub_cidr" {
  type        = string
  description = "Public subnet cidr"
  default     = "10.0.1.0/24"
}


variable "pub_sub_az" {
  type        = string
  description = "Public subnet az"
  default     = "ap-south-1a"
}


variable "pub_sub_name" {
  type        = string
  description = "public subnet name"
  default     = "pub_sub_tf"
}


variable "private_sub_cidr" {
  type        = string
  description = "Private subnet cidr"
  default     = "10.0.4.0/24"
}


variable "private_sub_az" {
  type        = string
  description = "Private subnet az"
  default     = "ap-south-1b"
}


variable "private_sub_name" {
  type        = string
  description = "Private subnet name"
  default     = "dev_private_sub_tf"
}


variable "igw_name" {
  type        = string
  description = "internet gateway name"
  default     = "igw_tf"
}

variable "rtb_name" {
  type        = string
  description = "internet route table  name"
  default     = "rtb_tf"
}


variable "sg_tag_name" {
  type        = string
  description = "security group tags name"
  default     = "sg_tf"
}

variable "sg_name" {
  type        = string
  description = "security group  name"
  default     = "sg_tf"
}