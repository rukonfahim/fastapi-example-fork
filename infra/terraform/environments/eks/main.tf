terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "networking" {
  source               = "../../modules/networking"
  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  admin_cidr_blocks    = var.admin_cidr_blocks
  tags                 = var.tags
}

module "security" {
  source               = "../../modules/security"
  name                 = var.name
  vpc_id               = module.networking.vpc_id
  allowed_http_cidrs   = var.allowed_http_cidrs
  allowed_https_cidrs  = var.allowed_https_cidrs
  admin_cidr_blocks    = var.admin_cidr_blocks
  tags                 = var.tags
}

module "iam" {
  source = "../../modules/iam"
  name   = var.name
}

resource "aws_eks_cluster" "main" {
  name     = "${var.name}-cluster"
  role_arn = module.iam.eks_cluster_role_arn

  vpc_config {
    subnet_ids = module.networking.private_subnet_ids
    security_group_ids = [module.security.eks_cluster_sg_id]
  }

  depends_on = [module.iam]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.name}-nodes"
  node_role_arn   = module.iam.eks_nodes_role_arn
  subnet_ids      = module.networking.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  instance_types = [var.node_instance_type]

  remote_access {
    ec2_ssh_key = var.key_name
    source_security_group_ids = [module.security.eks_nodes_sg_id]
  }

  depends_on = [aws_eks_cluster.main]
}
