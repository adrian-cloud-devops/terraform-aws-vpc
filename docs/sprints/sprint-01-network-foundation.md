[Back to README](../../README.md) | 
[Next: WIP →](wip.md)
# Sprint 1 — Networking Foundation

## Overview

The goal of this sprint was to establish the foundational AWS networking layer for the project.

This stage focused on creating the core VPC environment that will support the rest of the infrastructure.

A minimal but structured networking layout was implemented to enable future infrastructure expansion.

---

## Objectives

The objectives of this sprint were:

- create a dedicated VPC
- introduce subnet segmentation
- establish internet connectivity for public resources
- implement initial route tables
- define basic security groups

---

## Infrastructure Components

The following resources were introduced during this sprint:

- VPC
- Internet Gateway
- Public subnets
- Private subnets
- Route tables
- Security groups

These components provide the baseline networking environment required for future infrastructure components.

---

## Terraform Implementation

The infrastructure was implemented using Terraform.

The Terraform configuration defines:

- the AWS provider
- networking resources
- routing configuration
- security groups
- output variables

At this stage Terraform state is stored locally.

Remote state management will be introduced in a later sprint.

---

## Validation

The infrastructure deployment was validated by:

- reviewing the Terraform execution plan
- confirming resource creation in the AWS console
- verifying subnet associations with route tables
- confirming Internet Gateway connectivity

---

## Summary

This sprint established the foundational networking layer for the project.

The resulting VPC environment provides a structured base for future infrastructure development.

Additional networking capabilities and Terraform improvements will be introduced in the following sprints.