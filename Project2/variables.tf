variable "region" {
  type        = string
  description = "AWS region where resources will be created"
  default     = "us-east-1"
}

# variable "key_name" {
#   type    = string
#   default = "test-key-pair"
# }

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

