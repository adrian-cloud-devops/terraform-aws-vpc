[Back to README](../../README.md)  
[Next: Sprint-02 Terraform Refactor →](sprint-02-terraform-refactor.md)

# Sprint 01 — Networking Foundation

## Overview

The goal of Sprint 01 was to establish the foundational AWS networking layer for the project.

This stage focused on creating the core VPC environment that serves as the base for all future infrastructure components.

A structured networking layout was implemented to enable secure segmentation between public and private resources from the beginning.



## Objectives

- Create a dedicated VPC with a defined CIDR range
- Introduce public and private subnet segmentation across two Availability Zones
- Establish internet connectivity for public resources using an Internet Gateway
- Implement route tables to control traffic flow
- Define initial Security Groups to restrict access between layers



## Infrastructure Components

| Resource | Description |
|---|---|
| `aws_vpc` | Core network environment with DNS support enabled |
| `aws_internet_gateway` | Provides internet connectivity for public subnets |
| `aws_subnet` × 4 | Public and private subnets across two Availability Zones |
| `aws_route_table` × 2 | Separate routing logic for public and private subnets |
| `aws_route_table_association` × 4 | Associates each subnet with the correct route table |
| `aws_security_group` × 2 | Initial security boundaries for web and application layers |



## Networking Design

### VPC
```
10.0.0.0/16
```

The VPC provides an isolated network environment for all resources.

The `/16` CIDR range was selected to allow room for future subnet expansion across multiple environments.

DNS hostnames and DNS resolution were enabled to support internal name resolution within the VPC.

---

### Subnets

| Subnet | CIDR | Type | Availability Zone |
|---|---|---|---|
| public-subnet-a | 10.0.1.0/24 | Public | AZ-a |
| public-subnet-b | 10.0.2.0/24 | Public | AZ-b |
| private-subnet-a | 10.0.11.0/24 | Private | AZ-a |
| private-subnet-b | 10.0.12.0/24 | Private | AZ-b |

Subnets are distributed across two Availability Zones to lay the groundwork for high availability.

Public subnets have `map_public_ip_on_launch = true` — instances launched here receive a public IP automatically. Private subnets do not.

---

### Routing

**Public Route Table**
```
0.0.0.0/0 → Internet Gateway
```

Resources in public subnets can communicate directly with the internet.

**Private Route Table**
```
No internet route at this stage
```

Private subnets have no outbound internet access at this stage. Outbound connectivity via NAT Gateway is introduced in Sprint 03.

---

### Traffic Flow
```
Inbound internet access:
Internet → IGW → Public Subnet

Internal segmentation:
Public Subnet ←→ Private Subnet (controlled via Security Groups)
```



## Terraform Implementation

All resources were defined in a single flat configuration at this stage.
Terraform state is stored locally.

Both of these are intentional starting points — refactoring into modules and
migrating to remote state are addressed in Sprint 02.




## Security Groups

Two initial Security Groups were defined to establish the first layer of access control.

### Public Web Layer — `public-web-sg`

| Direction | Protocol | Port | Source |
|---|---|---|---|
| Inbound | TCP | 80 | 0.0.0.0/0 |
| Inbound | TCP | 443 | 0.0.0.0/0 |
| Outbound | All | All | 0.0.0.0/0 |

### Application Layer — `private-app-sg`

| Direction | Protocol | Port | Source |
|---|---|---|---|
| Inbound | TCP | 8080 | `public-web-sg` |
| Outbound | All | All | 0.0.0.0/0 |

`private-app-sg` references `public-web-sg` directly instead of using an open CIDR range — only traffic originating from the web layer is accepted.


## Validation

The infrastructure deployment was validated by:

- Reviewing the Terraform plan output before applying
- Confirming resource creation in the AWS Console
- Verifying subnet associations with correct route tables
- Confirming the Internet Gateway is attached to the VPC
- Checking that public subnets receive auto-assigned public IPs



## Key Takeaways

- The `/16` VPC CIDR provides enough address space for future multi-environment expansion
- Separating public and private subnets from day one enforces good security hygiene
- Using Security Group referencing instead of open CIDR rules reduces the attack surface
- Distributing subnets across two AZs prepares the architecture for high availability
- Flat Terraform configuration works for a minimal setup but becomes unmanageable quickly — refactored into modules in Sprint 02



## Next Steps

Sprint 02 focuses on improving the Terraform codebase by:

- Refactoring the flat configuration into reusable modules
- Introducing consistent resource tagging via `common_tags`
- Migrating Terraform state to a remote S3 backend
- Implementing state locking with DynamoDB

[⬆ Back to top](#sprint-01--networking-foundation)

---
[Back to README](../../README.md)  
[Next: Sprint-02 Terraform Refactor →](sprint-02-terraform-refactor.md)