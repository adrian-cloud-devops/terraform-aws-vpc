# AWS VPC Infrastructure with Terraform

This project demonstrates how to design and deploy a basic AWS networking architecture using Terraform.

The goal of the project is to build a production-like VPC environment using Infrastructure as Code and to demonstrate understanding of AWS networking fundamentals.

The infrastructure is built incrementally using development sprints, starting from a minimal networking setup and gradually introducing more advanced networking and Terraform best practices.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Networking Design](#networking-design)
- [Security Model](#security-model)
- [Project Structure](#project-structure)
- [Terraform Deployment](#terraform-deployment)
- [Outputs](#outputs)
- [Development Roadmap](#development-roadmap)
- [Future Improvements](#future-improvements)
- [Key Takeaways](#key-takeaways)

## Project Overview

This project provisions an AWS Virtual Private Cloud (VPC) environment using Terraform.

The architecture is designed to simulate a simplified production networking setup, including both public and private network segments distributed across multiple Availability Zones.

The purpose of the project is to demonstrate:

- Infrastructure as Code using Terraform
- AWS networking fundamentals
- high-availability networking design
- secure network segmentation
- structured Terraform project organization

The infrastructure is implemented incrementally through development sprints to simulate a realistic infrastructure evolution process.

## Architecture


The infrastructure deployed in the first stage of the project provides a foundational AWS networking layout.

The VPC spans two Availability Zones and contains both public and private subnets.

Public subnets provide internet-facing resources, while private subnets are designed to host internal services that are not directly accessible from the internet.

The use of two Availability Zones provides a basic high-availability foundation for future workloads.

A visual architecture diagram is included below:


![VPC Architecture](diagrams/vpc-architecture.png) 

 <!--  ## Project Structure
```text
terraform-vpc-project
│
├── README.md                      # Project overview and documentation entry point
│
├── provider.tf                    # Terraform and AWS provider configuration
├── main.tf                        # Core infrastructure resources
├── variables.tf                   # Input variables
├── terraform.tfvars               # Variable values
├── outputs.tf                     # Terraform outputs
│
└── diagrams                       # Architecture diagrams
    └── vpc-architecture.png
```
-->
## Networking Design

The networking architecture includes the following components:

### VPC

A dedicated Virtual Private Cloud with CIDR block:
```code
10.0.0.0/16
```
### Subnets

Four subnets distributed across two Availability Zones:

| Subnet | CIDR | Type |
|------|------|------|
| public-subnet-a | 10.0.1.0/24 | Public |
| public-subnet-b | 10.0.2.0/24 | Public |
| private-subnet-a | 10.0.11.0/24 | Private |
| private-subnet-b | 10.0.12.0/24 | Private |
### Routing

Two route tables control network traffic.

Public Route Table
```code
0.0.0.0/0 → Internet Gateway
```
Private Route Table

Private subnets currently have no direct internet route.

Internet egress will be introduced later using a NAT Gateway.

## Security Model

Two security groups are used to model a simple multi-tier architecture.

### Public Web Security Group

Allows inbound traffic from the internet:

- HTTP (80)

- HTTPS (443)

Outbound traffic is unrestricted.

### Private Application Security Group

Allows inbound traffic only from the public web security group:

- TCP 8080

This design ensures that backend services cannot be accessed directly from the internet.
# Project Structure

```text
terraform-vpc-project
│
├── README.md
│
├── provider.tf
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
│
├── diagrams
│   └── vpc-architecture.png
│
└── docs
    └── sprints
        ├── sprint-01-network-foundation.md
        ├── sprint-02-terraform-refactor.md
        ├── sprint-03-observability-endpoints.md
        └── sprint-04-nat-gateway.md
```
## Terraform Deployment

The infrastructure can be deployed using Terraform.

Initialize Terraform
```bash
terraform init
```
Validate configuration
```bash
terraform validate
```
Review the execution plan
```bash
terraform plan
```
Deploy infrastructure
```bash
terraform apply
```
Destroy infrastructure
```bash
terraform destroy
```
## Outputs

After deployment Terraform exposes the following outputs:
- `vpc_id`
- `public_subnet_a_id`
- `public_subnet_b_id`
- `private_subnet_a_id`
- `private_subnet_b_id`

These outputs make it easier to reference the created resources in future infrastructure modules.

## Development Roadmap

The infrastructure is developed incrementally using development sprints.

Each sprint introduces new networking or Terraform improvements while maintaining a working infrastructure baseline.

Detailed documentation for each stage is available below:

- [Sprint 1 — Networking Foundation](docs/sprints/sprint-01-network-foundation.md)
- [Sprint 2 — Terraform Structure Improvements](docs/sprints/sprint-02-terraform-refactor.md)
- [Sprint 3 — Observability and Endpoints](docs/sprints/sprint-03-flow-logs-endpoints.md)
- [Sprint 4 — NAT Gateway and Internet Egress](docs/sprints/sprint-04-nat-gateway.md)

Each sprint is documented in the `docs/sprints` directory.


## Future Improvements

Possible future extensions include:

- Application Load Balancer

- Auto Scaling Groups

- ECS workloads

- CI/CD pipeline integration

- multi-environment Terraform deployments

## Key Takeaways

This project demonstrates several important cloud engineering concepts:

- designing AWS networking architectures

- implementing Infrastructure as Code using Terraform

- building segmented network environments

- managing infrastructure state and dependencies

- structuring Terraform projects for maintainability

The project also highlights the importance of building infrastructure incrementally and validating each stage before introducing additional complexity.

---
[⬆ Back to top](#aws-vpc-infrastructure-with-terraform)