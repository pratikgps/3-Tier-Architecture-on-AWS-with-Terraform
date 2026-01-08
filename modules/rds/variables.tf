
variable "name" {
  description = "Name for the RDS instance"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the RDS instance into"
  type        = string
}

variable "subnets" {
  description = "List of private subnet IDs for the RDS instance"
  type        = list(string)
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}
variable "ecs_security_group_id" {
  description = "Security group ID of ECS instances"
  type        = string
}