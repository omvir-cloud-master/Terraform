variable "subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "security_group_id" {
  type = string
}


# variable "key_name" {
#   description = "EC2 Key Pair name"
#   type        = string
# }