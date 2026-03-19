output "vpc_id" {
  description = "ID of the main VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_a_id" {
  description = "ID of public subnet A"
  value       = module.subnets.public_subnet_a_id
}

output "public_subnet_b_id" {
  description = "ID of public subnet B"
  value       = module.subnets.public_subnet_b_id
}

output "private_subnet_a_id" {
  description = "ID of private subnet A"
  value       = module.subnets.private_subnet_a_id
}

output "private_subnet_b_id" {
  description = "ID of private subnet B"
  value       = module.subnets.private_subnet_b_id
}
output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = module.compute.bastion_public_ip
}

output "private_instance_private_ip" {
  description = "Private IP of private test host"
  value       = module.compute.private_instance_private_ip
}