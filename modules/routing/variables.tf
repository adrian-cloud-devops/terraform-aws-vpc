variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_a_id" {
  description = "ID of public subnet A"
  type        = string
}

variable "public_subnet_b_id" {
  description = "ID of public subnet B"
  type        = string
}

variable "private_subnet_a_id" {
  description = "ID of private subnet A"
  type        = string
}

variable "private_subnet_b_id" {
  description = "ID of private subnet B"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
}