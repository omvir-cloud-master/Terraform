variable "my_vpc_cidr" {
  type        = string
  description = "vpc cidr"
  default     = "10.0.0.0/16"
}


variable "my_vpc_name" {
  type        = string
  description = "vpc name"
  default     = "dev_vpc_tf"
}


variable "my_pub_sub_cidr" {
  type        = string
  description = "Public subnet cidr"
  default     = "10.0.1.0/24"
}


variable "my_pub_sub_az" {
  type        = string
  description = "Public subnet az"
  default     = "ap-south-1a"
}


variable "my_pub_sub_name" {
  type        = string
  description = "public subnet name"
  default     = "dev_pub_sub_tf"
}


variable "my_private_sub_cidr" {
  type        = string
  description = "Private subnet cidr"
  default     = "10.0.4.0/24"
}


variable "my_private_sub_az" {
  type        = string
  description = "Private subnet az"
  default     = "ap-south-1b"
}


variable "my_private_sub_name" {
  type        = string
  description = "Private subnet name"
  default     = "dev_private_sub_tf"
}


variable "my_igw_name" {
  type        = string
  description = "internet gateway subnet name"
  default     = "igw_tf"
}