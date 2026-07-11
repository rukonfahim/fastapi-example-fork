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

resource "aws_cloudwatch_log_group" "app" {
  name              = var.log_group_name
  retention_in_days = 30

  tags = var.tags
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.networking.public_subnet_ids[0]
  vpc_security_group_ids = [module.security.app_sg_id]
  iam_instance_profile   = module.iam.ec2_instance_profile_name
  key_name               = var.key_name

  user_data = templatefile("${path.module}/user_data.tpl", {
    app_env         = var.app_env
    container_image = var.container_image
    region          = var.region
    log_group_name  = aws_cloudwatch_log_group.app.name
  })

  tags = merge(var.tags, { Name = "${var.name}-app" })
}

resource "aws_lb" "app" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security.alb_sg_id]
  subnets            = module.networking.public_subnet_ids
}

resource "aws_lb_target_group" "app" {
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.networking.vpc_id

  health_check {
    path                = "/healthz"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app.id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
