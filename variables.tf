variable "aws_region" {
  type        = string
  description = "region name"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
}

variable "private_ips" {
  type        = list(string)
  description = "private ips"
}