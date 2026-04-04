# 🚀 Terraform AWS Infrastructure

![Banner](./snapshot.png)

This project provisions a complete AWS infrastructure using **Terraform** with a **modular architecture** and **remote state management**.

---

## 🏗️ Architecture Diagram

![Architecture](./architecture.png)

---

## 🔍 Architecture Overview

This infrastructure is deployed using Terraform and follows real-world DevOps practices.

### Workflow:

1. Engineer runs Terraform commands (`init`, `plan`, `apply`)
2. Terraform initializes providers and modules
3. State is stored remotely in **Amazon S3**
4. **DynamoDB** is used for state locking
5. A **VPC** is created with public subnets
6. An **EC2 instance** is deployed as a web server
7. An **RDS MySQL database** is provisioned
8. **Security Groups** manage access control between components

---

## ⚡ Key Highlights

- Modular Terraform architecture (`network`, `compute`, `database`)
- Remote state management using **S3 + DynamoDB**
- Infrastructure refactoring using `terraform state mv`
- Zero-downtime refactor (no resource destruction)
- Production-style infrastructure design

---

## 🧱 Project Structure

```
terraform-aws-iac/
│
├── modules/
│   ├── network/   # VPC, subnets, routing
│   ├── compute/   # EC2 instance + security group
│   └── database/  # RDS + subnet group
│
├── main.tf        # Root module (wiring layer)
├── variables.tf
├── outputs.tf
├── snapshot.png   # Web UI screenshot
├── architecture.png # Architecture diagram
└── README.md
```

---

## 🛠️ Tech Stack

- Terraform
- AWS (EC2, RDS, VPC, S3, DynamoDB)
- Infrastructure as Code (IaC)

---

## 🚀 Deployment

```bash
terraform init
terraform plan
terraform apply
```
## Remote State
- Stored in Amazon S3
- State locking handled via DynamoDB


## 🎯 What I Learned



- Designing modular Terraform architecture
- Managing infrastructure state safely
- Refactoring Terraform code without destroying resources
- Understanding dependencies between AWS components
- Applying real-world DevOps practices


## 🧩 Challenges & Solutions

### 1. Terraform planned to destroy and recreate resources after refactoring
After moving resources into modules, `terraform plan` initially showed destroy/recreate actions.  
To fix this, I used `terraform state mv` to migrate state entries from root resources to module resource addresses, so Terraform could continue managing the same AWS resources safely.

### 2. User data differences caused unexpected EC2 changes
After modularizing the compute configuration, Terraform still showed an in-place update for the EC2 instance because the `user_data` content no longer matched the original state exactly.  
I resolved this by reviewing the configuration and temporarily using `lifecycle { ignore_changes = [user_data] }` to avoid unnecessary updates during the refactor phase.

### 3. Git push/pull conflicts during project publishing
When publishing the project to GitHub, I encountered push rejection and pull conflicts caused by differences between local and remote files.  
I resolved them by synchronizing the repository properly, fixing `.gitignore`, and making sure untracked files such as diagrams were committed before rebasing and pushing.

### 4. Terraform destroy did not remove all resources visible in AWS Console
After running `terraform destroy`, some resources still appeared in the AWS Console.  
I verified that:
- EC2 instances in `terminated` state are already deleted but temporarily shown in the console
- default AWS VPC/subnets remain because Terraform did not create them
- backend resources such as S3 and DynamoDB must be removed manually if no longer needed

## 🧹 Cleanup

To remove Terraform-managed infrastructure:

```bash
terraform destroy
