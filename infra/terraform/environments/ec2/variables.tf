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
  default     = "10.10.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24"]
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

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.small"
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the autoscaling group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the autoscaling group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the autoscaling group"
  type        = number
  default     = 6
}

variable "target_http_requests_per_target" {
  description = "Target average HTTP requests per target for the autoscaling policy"
  type        = number
  default     = 25
}

variable "key_name" {
  description = "AWS SSH key pair name"
  type        = string
  default     = "fastapi-prod-key"
}

variable "container_image" {
  description = "Container image to run on the EC2 instances"
  type        = string
}

variable "app_env" {
  description = "Environment variables passed to the FastAPI container"
  type        = map(string)
  default     = {}
}

variable "log_group_name" {
  description = "CloudWatch log group for container logs"
  type        = string
  default     = "/aws/ec2/fastapi"
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
