output "flow_log_id" {
  description = "ID of the VPC Flow Log"
  value       = aws_flow_log.vpc_flow_logs.id
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group used for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_logs.name
}