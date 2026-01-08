
variable "name" {
  description = "Name for the ALB resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the ALB into"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}
