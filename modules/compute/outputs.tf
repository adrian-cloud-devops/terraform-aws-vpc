output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Private IP of the bastion host"
  value       = aws_instance.bastion.private_ip
}

output "private_instance_private_ip" {
  description = "Private IP of the private test instance"
  value       = aws_instance.private_test.private_ip
}