


# Deploying a 3-Tier Architecture on AWS with Terraform

This project deploys a 3-tier web application architecture on Amazon Web Services (AWS) using Terraform. It includes a VPC with public and private subnets, an Application Load Balancer, an ECS cluster running an Nginx container, and an RDS PostgreSQL database.

## Infrastructure Components

### The following AWS resources are created:

*   **VPC**: A Virtual Private Cloud to provide an isolated network environment.
*   **Subnets**: Public and private subnets across two availability zones.
*   **Internet Gateway**: To provide internet access to the public subnets.
*   **NAT Gateway**: To allow resources in the private subnets to access the internet.
*   **Application Load Balancer (ALB)**: To distribute incoming web traffic to the ECS service.
*   **ECS (Elastic Container Service)**: To run the Nginx web server as a Fargate task.
*   **RDS (Relational Database Service)**: A PostgreSQL database instance in the private subnets.
*   **Security Groups**: To control traffic between the different components.

## The Problem: `terraform apply` Failure

When initially running `terraform apply`, the deployment failed with two main errors:

1.  **Unsupported Attribute**: The `main.tf` file tried to access an output variable `ecs_security_group_id` from the `ecs` module, but this output was not defined in the module.
2.  **Reference to Undeclared Resource**: The `rds` module's `outputs.tf` file was trying to reference a security group that was not defined within that module.


## 🔍 Troubleshooting and Resolution

### 1️⃣ Validation
- Executed `terraform validate` to identify exact configuration errors.

### 2️⃣ ECS Module Fix
- Found the ECS task security group defined as:
*   Inspected `modules/ecs/main.tf` and found that the security group for the ECS tasks was being created with the name `aws_security_group.ecs_tasks`.  
*   Inspected `modules/ecs/outputs.tf` and confirmed that there was no output for the security group ID.
*   Added the following output to `modules/ecs/outputs.tf` to expose the security group ID:

  ```terraform                                                                                                
       output "ecs_security_group_id" {                                                                           
          description = "The ID of the security group for the ECS tasks"                                           
          value       = aws_security_group.ecs_tasks.id                                                          
         }                                                                                                           
  ```

### 3️⃣ RDS Module Fix

* Removed an incorrect output in modules/rds/outputs.tf that referenced
* ECS resources outside the module.

* Ensured the RDS module only manages database-related resources.

### 4️⃣ Confirmation

* terraform validate completed successfully.
* terraform plan showed expected changes.
* terraform apply executed without errors ✅


### 🚀 How to Deploy

1.  **Initialize Terraform**:
     ```bash
     terraform init
     ```
2.  **Plan the Deployment**:
     ```bash
     terraform plan
     ```

## Troubleshooting and Resolution

The following steps were taken to diagnose and resolve the errors:

1.  **Validation**: Ran `terraform validate` to get a detailed error report, which pointed to the exact lines in the configuration that were causing the issues.

2.  **ECS Module Fix**:
    *   Inspected `modules/ecs/main.tf` and found that the security group for the ECS tasks was being created with the name `aws_security_group.ecs_tasks`.
    *   Inspected `modules/ecs/outputs.tf` and confirmed that there was no output for the security group ID.
    *   Added the following output to `modules/ecs/outputs.tf` to expose the security group ID:
      
        ```terraform
        output "ecs_security_group_id" {
          description = "The ID of the security group for the ECS tasks"
          value       = aws_security_group.ecs_tasks.id
        }
        ```

3.  **RDS Module Fix**:
    *   Inspected `modules/rds/outputs.tf` and found an incorrect output that was trying to reference a resource outside of the module's scope.
    *   Removed the incorrect `ecs_security_group_id` output from `modules/rds/outputs.tf`. The RDS module should not be concerned with ECS resources.

4.  **Confirmation**: After applying the fixes, `terraform validate` ran successfully. `terraform plan` showed the expected changes, and `terraform apply` completed without any errors.

## How to Deploy

1.  **Initialize Terraform**:
    ```bash
    terraform init
    ```
2.  **Plan the Deployment**:
    ```bash
    terraform plan
    ```

3.  **Apply the Configuration**:
    ```bash
    terraform apply
    ```


## ✅ How to Verify the Deployment

1.  **Access the Web Server**:
    *   Open a web browser and navigate to the `alb_dns_name` provided in the `terraform apply` output. You should see the "Welcome to nginx!" page.

## How to Verify the Deployment

1.  **Access the Web Server**: Open a web browser and navigate to the `alb_dns_name` provided in the `terraform apply` output. You should see the "Welcome to nginx!" page.

2.  **Check the AWS Console**:
    *   **ECS Cluster**: Navigate to the ECS console and check that the `my-ecs` cluster has a service with one running task.
    *   **RDS Database**: Navigate to the RDS console and check that the `myrds` database instance has a status of `Available`.
    *   **ALB Target Group**: Navigate to the EC2 console, go to "Target Groups," and check that the `my-alb-tg` target group has one `healthy` target.

### 📚 Topics Covered

 * Terraform Modules and Reusability.
 * AWS VPC, Subnets, NAT & Internet Gateways.
 * Application Load Balancer (ALB).
 * ECS Fargate and Containerized Applications.
 * Amazon RDS (PostgreSQL).
 * Terraform Variables and Outputs.
 * AWS Security Groups.
 * Terraform Debugging and Validation.


### 📈 Key Learnings

 * Designing secure AWS network architectures.
 * Terraform module isolation and outputs.
 * Debugging Terraform errors effectively.
 * ECS Fargate with ALB integration.
 * Secure communication using security groups.

### 📊 Architecture Diagram (ASCII – Copy Paste)
```
                    ┌────────────────────────┐
                    │        Internet        │
                    └────────────────────────┘
                                │
                     ┌──────────▼──────────┐
                     │ Application Load     │
                     │ Balancer (ALB)       │
                     │ (Public Subnets)     │
                     └──────────┬──────────┘
                                │
                 ┌──────────────▼──────────────┐
                 │        ECS Cluster           │
                 │      (Fargate Tasks)         │
                 │     Nginx Web Server         │
                 │     (Private Subnets)        │
                 └──────────────┬──────────────┘
                                │
                 ┌──────────────▼──────────────┐
                 │     Amazon RDS (Postgres)   │
                 │        Private Subnets      │
                 └─────────────────────────────┘
```


## Topics Covered

*   **Terraform Modules**: Structuring infrastructure code into reusable modules.
*   **AWS Networking**: VPC, Subnets, NAT Gateways, and Internet Gateways.
*   **AWS Application Load Balancer (ALB)**: Distributing traffic to backend services.
*   **AWS Elastic Container Service (ECS)**: Running containerized applications with Fargate.
*   **AWS Relational Database Service (RDS)**: Deploying a managed PostgreSQL database.
*   **Terraform Variables**: Using input and output variables to pass data between modules.
*   **AWS Security Groups**: Defining firewall rules to control network traffic.
*   **Terraform Troubleshooting**: Using `validate` and `plan` to diagnose and fix configuration errors.

## 🧑‍💻 Author

### Pratik Gupta
 ***DevOps Engineer | AWS | Terraform***

