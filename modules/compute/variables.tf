variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "bastion_sg_id" {
  description = "ID of bastion security group"
  type        = string
}

variable "private_test_sg_id" {
  description = "ID of private test security group"
  type        = string
}