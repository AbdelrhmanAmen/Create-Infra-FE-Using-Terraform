# Create-Infra-FLexibleEngine-Using-Terraform

## Purpose
> - Create and provision resources in FE(Flexible Engine) cloud `Note you need to have FE account`.
---
## Created Resources
> - VPC
> - Subnet
> - Security Group and Rules
> - Key pair for accessing the ECS
> - ECS instance bounded to EIP
---
## Project RUN
   1. `terraform init` intialize the project with all required modules and files of the cloud provider. 
   2. `terraform plan` validate all resources (dry-run technique). 
   3. `terraform apply` Create all resources (the real effect).
---
## How to use 
> - create a `terraform.tfvars` and provide your values for variables in the `variable.tf` file.

