[← Previous: Sprint-01 Network Foundation](sprint-01-network-foundation.md)  
[Back to README](../../README.md)  
[Next: Sprint-03 Advanced Networking →](sprint-03-advanced-networking.md)  

# Sprint 02 — Terraform Refactor and Remote State

## Overview

The goal of Sprint 02 was to improve infrastructure code quality and introduce
production-grade Terraform practices.

During this sprint the flat Terraform configuration was refactored into reusable
modules, Terraform state was migrated safely to a remote backend, and state locking
was implemented to prevent concurrent changes.



## Objectives

- Refactor flat Terraform configuration into reusable modules
- Introduce consistent resource tagging using `common_tags`
- Safely migrate Terraform state after refactor using `terraform state mv`
- Implement remote state storage in S3
- Enable state locking with DynamoDB



## Infrastructure Components

| Resource | Description |
|---|---|
| `modules/vpc` | Isolated core VPC resource |
| `modules/subnets` | Public and private subnet definitions |
| `modules/routing` | IGW, route tables, route associations |
| `modules/security` | Security Groups for all network layers |
| S3 bucket | Remote Terraform state storage |
| DynamoDB table | State locking mechanism |



## Module Structure

The flat configuration was reorganized into four modules:
```text
modules/
│
├── vpc/          # Core VPC resource
├── subnets/      # Public and private subnet definitions
├── routing/      # IGW, route tables, route associations
└── security/     # Security Groups for all layers
```

Each module is responsible for a single infrastructure concern and exposes
its resources through output variables consumed by the root module.



## Module Responsibilities

### `vpc`

Creates the main VPC with DNS support enabled.

Resources: `aws_vpc`

---

### `subnets`

Defines public and private subnet segmentation across two Availability Zones.
Public subnets have `map_public_ip_on_launch = true`. Private subnets do not.

Resources: `aws_subnet` 

---

### `routing`

Handles internet connectivity and routing logic for both public and private subnets.

Resources: `aws_internet_gateway`, `aws_route_table` , `aws_route_table_association` 

 `aws_nat_gateway` and `aws_eip` also live in this module but are introduced
 in Sprint 03. At this stage the private route table has no outbound internet route.

---

### `security`

Defines Security Groups for all network layers. Internal communication uses
Security Group referencing — no open CIDR rules between internal components.

Resources: `aws_security_group` × 4



## Shared Resource Tagging

A `common_tags` variable was introduced to enforce consistent tagging across
all AWS resources. Tags are applied using `merge()` so each resource inherits
the shared set while adding its own `Name` tag.

| Tag | Value |
|---|---|
| `Environment` | `dev` |
| `Project` | `terraform-aws-vpc-project` |
| `ManagedBy` | `Terraform` |



## Terraform State Migration

After introducing modules, Terraform resource addresses changed. For example:
```
Before:  aws_vpc.main_vpc
After:   module.vpc.aws_vpc.main_vpc
```

Without migration, Terraform would treat the old address as deleted and the new
one as a new resource — destroying and recreating existing infrastructure.

`terraform state mv` was used to remap addresses in the state file without
touching any actual AWS resources. This allowed the full refactor to be completed
with zero downtime and no resource recreation.



## Remote Terraform State

Local state was replaced with a remote S3 backend.

| Setting | Value |
|---|---|
| Storage | S3 bucket |
| Encryption | Enabled |
| State locking | DynamoDB table |
| Region | `eu-central-1` |

Benefits over local state:

- State file is not stored in the repository
- Enables safe collaboration in team workflows
- Protected against concurrent modifications via DynamoDB locking



## State Locking with DynamoDB

DynamoDB prevents concurrent Terraform operations from modifying infrastructure
at the same time.
```
terraform apply starts
        │
        ▼
DynamoDB creates lock entry
        │
        ▼
Terraform executes changes
        │
        ▼
Lock is released on completion
```

If a second operation is attempted while a lock is held, Terraform refuses to
proceed and displays the lock ID — preventing conflicting changes.


## Backend Bootstrap

Terraform cannot create the S3 bucket and DynamoDB table it uses as a backend.
A separate `bootstrap/` configuration was created to provision these resources
as a one-time setup step applied before the main infrastructure is initialized.

The bootstrap configuration creates:

- S3 bucket for Terraform state storage
- DynamoDB table for state locking



## Project Structure After Refactor
```text
terraform-aws-vpc-project
│
├── bootstrap/
│
├── modules/
│   ├── vpc/
│   ├── subnets/
│   ├── routing/
│   └── security/
│
├── backend.tf
├── data.tf
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```



## Validation

The refactor was validated by:

- Confirming `terraform plan` showed no resource changes after state migration
- Verifying all resources retained their existing AWS resource IDs
- Confirming state file is stored in S3 and no longer exists locally
- Testing DynamoDB locking by observing lock entry creation during `terraform apply`



## Key Takeaways

- Modular Terraform design separates concerns and makes the codebase easier
  to extend — each sprint adds new modules without touching existing ones
- `terraform state mv` is essential when refactoring — skipping it causes
  Terraform to destroy and recreate existing resources
- The `bootstrap/` pattern solves the chicken-and-egg problem of Terraform
  needing infrastructure to store its own state
- Remote state with S3 and DynamoDB locking is the standard approach for any
  team or production environment



## Next Steps

Sprint 03 extends the networking layer with:

- NAT Gateway for outbound internet access from private subnets
- Elastic IP for the NAT Gateway
- S3 Gateway Endpoint to route AWS traffic internally
- VPC Flow Logs with CloudWatch delivery

[⬆ Back to top](#sprint-02--terraform-refactor-and-remote-state)

---
[← Previous: Sprint-01 Network Foundation](sprint-01-network-foundation.md)  
[Back to README](../../README.md)  
[Next: Sprint-03 Advanced Networking →](sprint-03-advanced-networking.md)  