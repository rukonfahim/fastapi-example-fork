variable "name" {
  description = "Base name for the networking resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks allowed for SSH administration"
  type        = list(string)
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
