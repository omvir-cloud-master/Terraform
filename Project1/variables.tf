# AWS Region
variable "region" {
  type        = string
  description = "AWS region where resources will be created"
  default     = "ap-south-1"
}

# VPC
variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

# Public Subnet
variable "pub_sub_name" {
  type        = string
  description = "Name of the public subnet"
}

variable "pub_sub_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
}

variable "pub_sub_az" {
  type        = string
  description = "Availability Zone for the public subnet"
}

# Private Subnet
variable "private_sub_name" {
  type        = string
  description = "Name of the private subnet"
}

variable "private_sub_cidr" {
  type        = string
  description = "CIDR block for the private subnet"
}

variable "private_sub_az" {
  type        = string
  description = "Availability Zone for the private subnet"
}

# Internet Gateway
variable "igw_name" {
  type        = string
  description = "Name of the Internet Gateway"
}

# Route Table
variable "rtb_name" {
  type        = string
  description = "Name of the Route Table"
}

# Security Group
variable "sg_name" {
  type        = string
  description = "Name of the Security Group"
}

variable "sg_tag_name" {
  type        = string
  description = "Tag name for the Security Group"
}