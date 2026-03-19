[← Previous: Sprint-02 Terraform Refactor](sprint-02-terraform-refactor.md)  
[Back to README](../../README.md)  
[Next: Sprint-04 Compute Layer →](sprint-04-compute-layer-validation.md)  

# Sprint 03 — Advanced Networking

## Overview

The goal of Sprint 03 was to extend the VPC architecture with additional networking
capabilities typically used in production AWS environments.

During this sprint the infrastructure was extended with outbound internet connectivity
for private subnets, optimized routing for internal AWS traffic, and network-level
observability through VPC Flow Logs.



## Objectives

- Enable controlled outbound internet access from private subnets via NAT Gateway
- Reduce NAT Gateway cost and improve security using an S3 Gateway Endpoint
- Introduce network observability using VPC Flow Logs
- Deliver flow log data to CloudWatch Logs with appropriate IAM permissions
- Extend the modular Terraform structure with two new modules



## Infrastructure Components

| Resource | Module | Description |
|---|---|---|
| `aws_eip` | `routing` | Elastic IP address for the NAT Gateway |
| `aws_nat_gateway` | `routing` | Managed NAT for outbound private subnet traffic |
| `aws_vpc_endpoint` | `endpoints` | S3 Gateway Endpoint for internal AWS traffic |
| `aws_flow_log` | `observability` | VPC-level network traffic capture |
| `aws_cloudwatch_log_group` | `observability` | Log destination for Flow Logs |
| `aws_iam_role` | `observability` | Allows Flow Logs service to write to CloudWatch |
| `aws_iam_role_policy` | `observability` | Grants required CloudWatch Logs permissions |



## Module Structure After Sprint 03

Two new modules were introduced:
```text
modules/
│
├── vpc/
├── subnets/
├── routing/          # Extended: + aws_eip, aws_nat_gateway
├── security/
├── endpoints/        # New: S3 Gateway Endpoint
└── observability/    # New: Flow Logs, CloudWatch, IAM
```



## NAT Gateway

Private subnets have no public IP addresses and cannot receive inbound connections
from the internet. However, private workloads often still need outbound connectivity
to download packages, access external APIs, or reach external services.

A NAT Gateway was deployed in the public subnet to provide this capability
without exposing private instances directly.

The `routing` module was extended with `aws_eip` and `aws_nat_gateway` resources.
The private route table was updated to route all outbound traffic through the
NAT Gateway.

Traffic flow after this change:
```
Private EC2
    │
    ▼
Private Route Table (0.0.0.0/0 → NAT Gateway)
    │
    ▼
NAT Gateway (public subnet)
    │
    ▼
Internet Gateway
    │
    ▼
Internet
```



## S3 Gateway Endpoint

Without an endpoint, traffic from private subnets to S3 would route through
the NAT Gateway — adding cost and sending internal AWS traffic over the public
internet.

An S3 Gateway Endpoint routes this traffic directly through the AWS internal
network instead. The endpoint is associated with the private route table.
AWS automatically injects a prefix list entry — no manual route configuration
is needed in Terraform.

Traffic flow for S3 access:
```
Private EC2
    │
    ▼
Private Route Table (prefix list → S3 Gateway Endpoint)
    │
    ▼
Amazon S3 (via AWS internal network)
```

Benefits:

- Traffic never leaves the AWS network
- No NAT Gateway data processing charges for S3 traffic
- S3 Gateway Endpoints have no hourly or data transfer cost



## VPC Flow Logs

VPC Flow Logs capture metadata about network traffic flowing through the VPC.
This provides visibility into accepted and rejected connections for troubleshooting
and security analysis.

Flow Logs capture metadata only — source IP, destination IP, port, protocol,
bytes, and action. Packet content is not recorded.

| Setting | Value |
|---|---|
| Traffic type | `ALL` (accepted and rejected) |
| Destination | CloudWatch Logs |
| Log retention | 7 days |
| Scope | Entire VPC |

A 7-day retention policy on the CloudWatch Log Group prevents unbounded
storage cost accumulation.



## IAM Role for Flow Logs

The VPC Flow Logs service requires an IAM role to publish log data to CloudWatch.
The trust policy restricts assumption of this role to the
`vpc-flow-logs.amazonaws.com` service only.

The role grants the following CloudWatch Logs permissions:
```
logs:CreateLogGroup
logs:CreateLogStream
logs:PutLogEvents
logs:DescribeLogGroups
logs:DescribeLogStreams
```



## Verification

After deployment the following were verified in the AWS Console:

**NAT Gateway**
```
Status:   Available
Subnet:   public-subnet-a
EIP:      attached
```

**Private Route Table**
```
0.0.0.0/0    → nat-gateway-id
pl-xxxxxx    → vpce-xxxxxx (S3 prefix list, injected automatically)
```

**S3 Gateway Endpoint**
```
Type:          Gateway
Service:       com.amazonaws.eu-central-1.s3
Route tables:  private-route-table
Status:        Available
```

**VPC Flow Logs**
```
Status:        Active
Traffic type:  ALL
Destination:   CloudWatch Logs — /aws/vpc/flow-logs
```



## Key Takeaways

- NAT Gateway must be placed in a public subnet and requires an Elastic IP —
  it provides outbound-only internet access for private resources
- `depends_on = [aws_internet_gateway.igw]` is required in the NAT Gateway
  resource to prevent provisioning race conditions
- S3 Gateway Endpoints are free — no hourly charge or data processing fee,
  unlike NAT Gateway which charges for both
- The endpoint prefix list route is injected into the route table automatically
  by AWS — no manual route entry is needed in Terraform
- VPC Flow Logs capture metadata only — they do not record packet content
- Separating observability into its own module keeps IAM, CloudWatch, and
  Flow Log resources isolated from networking concerns



## Next Steps

Sprint 04 deploys the compute layer to validate that all networking and security
configurations work correctly in a real access scenario:

- Bastion Host in the public subnet
- Private EC2 instance in the private subnet
- End-to-end SSH connectivity validation
- Outbound internet connectivity test from the private instance

[⬆ Back to top](#sprint-03--advanced-networking)

---
[← Previous: Sprint-02 Terraform Refactor](sprint-02-terraform-refactor.md)  
[Back to README](../../README.md)  
[Next: Sprint-04 Compute Layer →](sprint-04-compute-layer-validation.md)  