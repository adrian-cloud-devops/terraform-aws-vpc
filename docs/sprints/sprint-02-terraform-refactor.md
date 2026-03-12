[← Previous: Sprint-01 Network Foundation](sprint-01-network-foundation.md)  
[Back to README](../../README.md)   
[Next: Sprint-03 Advanced Networking →](sprint-03-advanced-networking.md)  
# Sprint 02 – Terraform Refactor and Remote State
## Overview

The goal of Sprint 02 was to improve the infrastructure code quality and introduce production-grade Terraform practices.

During this sprint the Terraform configuration was refactored into reusable modules, existing infrastructure state was migrated safely, and a remote backend with state locking was implemented.

This ensures that infrastructure changes are safer, more maintainable, and closer to real-world DevOps workflows.

## Objectives

The main objectives of this sprint were:

- Refactor Terraform configuration into modules
- Introduce shared resource tagging
- Safely migrate Terraform state after refactor
- Implement remote state storage
- Enable state locking to prevent concurrent changes

## Terraform Module Refactor

Initially the project contained a single Terraform configuration with all resources defined in one file.

To improve maintainability and scalability the configuration was reorganized into reusable modules.

Module Structure
```text
modules/
│
├── vpc
├── subnets
├── routing
└── security
```
Each module is responsible for a specific infrastructure component.

## Responsibilities of each module

### vpc
Creates the main VPC and enables DNS features.

Resources:
- aws_vpc
### subnets
Defines network segmentation across availability zones.

Resources:
- public subnets
- private subnets
### routing
Handles internet connectivity and routing logic.

Resources:
- Internet Gateway
- Route tables
- Route table associations
### security
Defines network security boundaries.

Resources:
- Security groups for public web layer
- Security groups for private application layer

## Shared Resource Tagging

A common tagging strategy was introduced to improve resource management and observability.

Example tag set:

- `Environment = dev`
- `Project     = terraform-aws-vpc-project`
- `ManagedBy   = Terraform`

These tags are applied across infrastructure using a shared variable:

- `common_tags`

This ensures consistent tagging across all AWS resources.

## Terraform State Migration

After introducing modules, Terraform resource addresses changed.

For example:

Before refactor:
```hcl
aws_vpc.main_vpc
```
After refactor:
```hcl
module.vpc.aws_vpc.main_vpc
```
To avoid destroying existing infrastructure the Terraform state was migrated using:
```hcl
terraform state mv
```
Example:
```hcl
terraform state mv aws_vpc.main_vpc module.vpc.aws_vpc.main_vpc
```
This allowed the refactor to be completed without recreating resources.

## Remote Terraform State

Local Terraform state was replaced with a remote backend.
Remote state improves collaboration, reliability, and disaster recovery.
The state is now stored in an S3 bucket.

Example backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "vpc-project/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
```

## State Locking with DynamoDB

To prevent concurrent infrastructure changes Terraform state locking was implemented using DynamoDB.

Locking mechanism:
```text
Terraform operation starts
        │
        ▼
DynamoDB creates temporary lock
        │
        ▼
Terraform executes changes
        │
        ▼
Lock removed after completion
```
This ensures that only one Terraform operation can modify infrastructure at a time.

## Backend Bootstrap

Terraform cannot create the backend it uses.
To solve this a small bootstrap configuration was created.

Directory: `bootstrap/`

This configuration creates:

- S3 bucket for Terraform state
- DynamoDB table for state locking

The bootstrap configuration is applied once during project setup.

## Project Structure After Refactor
```text
terraform-aws-vpc-project
│
├── bootstrap
│
├── modules
│   ├── vpc
│   ├── subnets
│   ├── routing
│   └── security
│
├── diagrams
├── docs
│
├── backend.tf
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── data.tf
│
└── terraform.tfvars
```
## Key Improvements Achieved

This sprint significantly improved the infrastructure codebase.

Improvements include:

- Modular Terraform architecture
- Safe state migration
- Remote state storage
- DynamoDB state locking
- Consistent resource tagging
- Improved project structure

These practices align with real-world Infrastructure as Code workflows used in production environments.

## Next Steps

Sprint 03 will focus on improving the networking architecture by introducing production-grade networking components such as:

- NAT Gateway for outbound internet access from private subnets
- Elastic IP required by the NAT Gateway
- VPC Flow Logs
- CloudWatch Log Group for Flow Logs delivery

## Summary

Sprint 02 transformed the Terraform configuration from a basic infrastructure setup into a more robust and production-ready Infrastructure as Code project.

Key DevOps practices introduced in this sprint include:

- modular Terraform design
- remote backend usage
- safe state migration
- infrastructure locking mechanisms

These improvements significantly increase the reliability and maintainability of the infrastructure.

[⬆ Back to top](#sprint-02--terraform-refactor-and-remote-state)

---
[← Previous: Sprint-01 Network Foundation](sprint-01-network-foundation.md)  
[Back to README](../../README.md)   
[Next: Sprint-03 Advanced Networking →](sprint-03-advanced-networking.md)  