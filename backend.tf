terraform {
  backend "s3" {
    bucket         = "adrian-terraform-state-vpc-project-2026"
    key            = "vpc-project/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}