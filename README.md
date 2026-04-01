# Terraform AWS Infrastructure

This project provisions AWS infrastructure using Terraform with a modular architecture.

## Features
- VPC and public subnets
- EC2 web server
- RDS MySQL database
- Remote state with S3 and DynamoDB
- Safe module refactor using `terraform state mv`

## Project Structure
- modules/network
- modules/compute
- modules/database

## Tech Stack
- Terraform
- AWS (EC2, RDS, VPC)
- S3 + DynamoDB (remote state)

## Key Learning
This project demonstrates how to refactor Terraform code into modules without destroying existing infrastructure.