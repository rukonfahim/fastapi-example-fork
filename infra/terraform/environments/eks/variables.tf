variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Base name for resources"
  type        = string
  default     = "fastapi-prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.20.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "allowed_http_cidrs" {
  description = "Allowed HTTP CIDRs"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidrs" {
  description = "Allowed HTTPS CIDRs"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks allowed for SSH"
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

variable "node_instance_type" {
  description = "EKS worker node instance size"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "AWS SSH key pair name"
  type        = string
  default     = "fastapi-prod-key"
}

variable "app_image" {
  description = "Container image for the FastAPI workload"
  type        = string
}

variable "app_env" {
  description = "Environment variables passed to the FastAPI container"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "fastapi-example"
    ManagedBy   = "terraform"
  }
}
