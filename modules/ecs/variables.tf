
variable "name" {
  description = "Name for the ECS resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC for ECS"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ECS"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs for ECS"
  type        = list(string)
}

variable "alb_target_group" {
  description = "ARN of the ALB target group for ECS service"
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the ALB security group to allow inbound traffic from"
  type        = string
}
