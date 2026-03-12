variable "state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform remote state"
  type        = string
  default     = "adrian-terraform-state-vpc-project-2026"
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  type        = string
  default     = "terraform-state-locks"
}