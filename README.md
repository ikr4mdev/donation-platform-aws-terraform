# Donation Platform – AWS Infrastructure with Terraform

## Overview

This project contains modular Terraform configuration for the AWS infrastructure of a donation platform.

The architecture is designed to support a containerized application with separate frontend and backend services, private database and cache layers, and controlled network access.

### AWS Services

- Amazon VPC
- Application Load Balancer (ALB)
- Amazon ECS with Fargate
- Amazon ECR
- Amazon RDS for PostgreSQL
- Amazon ElastiCache for Valkey
- AWS IAM
- AWS Secrets Manager
- AWS Cloud Map
- Amazon CloudWatch

## Architecture

The infrastructure follows a three-tier network architecture.

### 1. Public Layer

- **Application Load Balancer:** Receives incoming HTTP traffic and forwards requests to the frontend service.
- **Internet Gateway:** Provides internet connectivity to public subnets.
- **NAT Gateway:** Allows resources in application-private subnets to access external services.

### 2. Application Layer

- **Amazon ECS with Fargate:** Runs the Next.js frontend and NestJS backend as separate containerized services.
- **AWS Cloud Map:** Provides private DNS-based service discovery for communication with the NestJS service.

### 3. Data Layer

- **Amazon RDS for PostgreSQL:** Provides relational database storage.
- **Amazon ElastiCache for Valkey:** Provides an in-memory caching layer.
- Both services are configured to use private data subnets.

### Container Image Management

- **Amazon ECR:** Stores the frontend and backend Docker images.

### Security and Configuration

- **AWS IAM:** Separates ECS execution permissions from application task roles.
- **AWS Secrets Manager:** Stores database credentials and application token secrets.

## Project Structure

```text
terraform/
├── main.tf
├── variables.tf
├── versions.tf
├── terraform.tfvars
├── .gitignore
├── README.md
└── modules/
    ├── alb/
    ├── cloudwatch/
    ├── ecr/
    ├── ecs/
    ├── iam/
    ├── rds/
    ├── redis/
    ├── secret/
    ├── sg/
    └── vpc/
```

### Module Responsibilities

| Module | Responsibility |
|---|---|
| `vpc` | Creates the VPC, subnets, internet gateway, route tables, and NAT gateway. |
| `sg` | Defines security groups and network traffic rules. |
| `alb` | Configures the Application Load Balancer and frontend target group. |
| `ecs` | Defines the ECS cluster, task definitions, and application services. |
| `ecr` | Creates container image repositories and lifecycle policies. |
| `iam` | Defines ECS execution and application task roles and permissions. |
| `rds` | Configures the PostgreSQL database. |
| `redis` | Configures the Valkey replication group. |
| `secret` | Stores application and database secrets in Secrets Manager. |
| `cloudwatch` | Defines separate log groups for frontend and backend services. |

**Note:** The CloudWatch module is currently standalone and is not integrated with the ECS services.

## Network Flow

The intended application traffic flow is:

1. Internet traffic reaches the public Application Load Balancer.
2. The ALB forwards HTTP traffic to the Next.js frontend running on ECS Fargate.
3. The Next.js frontend communicates with the NestJS backend through private service discovery using AWS Cloud Map.
4. The NestJS backend connects to PostgreSQL and Valkey in the private data subnets.

### Network Isolation

- Public subnets host the internet-facing ALB and NAT Gateway.
- Application-private subnets host the ECS services.
- Data-private subnets host PostgreSQL and Valkey.
- Security groups restrict communication between application components.
- The data layer has no direct internet route.

## Security

- Application services are configured to run in private subnets.
- PostgreSQL and Valkey are isolated in private data subnets.
- Security groups restrict network access between services.
- IAM roles separate infrastructure execution permissions from application permissions.
- Sensitive configuration is stored in AWS Secrets Manager.
- Database storage and Valkey encryption are enabled in the configuration.

## Project Status

- Terraform modules and infrastructure configuration have been written.
- Terraform and AWS provider version constraints are defined.
- The configuration has not been deployed to AWS.
- Terraform CLI validation has not yet been performed.
- HTTPS with ACM and CloudWatch integration are not yet implemented.

## Future Improvements

- Configure HTTPS using AWS Certificate Manager.
- Integrate CloudWatch log groups with ECS services.
- Validate the configuration using the Terraform CLI.
- Improve deployment documentation.