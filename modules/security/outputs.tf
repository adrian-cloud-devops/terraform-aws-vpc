output "public_web_sg_id" {
  description = "ID of public web security group"
  value       = aws_security_group.public_web_sg.id
}

output "private_app_sg_id" {
  description = "ID of private app security group"
  value       = aws_security_group.private_app_sg.id
}
output "bastion_sg_id" {
  description = "ID of bastion security group"
  value       = aws_security_group.bastion_sg.id
}

output "private_test_sg_id" {
  description = "ID of private test security group"
  value       = aws_security_group.private_test_sg.id
}