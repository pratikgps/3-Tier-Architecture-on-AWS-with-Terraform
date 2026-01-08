
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "ezs" {
  description = "A list of availability zones"
  type        = list(string)
}

variable "name" {
  description = "Name for the VPC resources"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}
