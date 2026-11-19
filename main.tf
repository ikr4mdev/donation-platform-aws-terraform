# ============================================================
# VPC
# ============================================================

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  app_private_subnets = var.app_private_subnets
  data_private_subnets = var.data_private_subnets
  enable_dns_hostname = var.enable_dns_hostname
  enable_dns_support = var.enable_dns_support
  anywhere = var.anywhere
  tags = var.tags
}

# ============================================================
# SECURITY GROUPS
# ============================================================

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  anywhere_cidr = var.anywhere
  tags = var.tags
}

# ============================================================
# ECR
# ============================================================

module "ecr" {
  source = "./modules/ecr"
  image_tag_mutability = var.image_tag_mutability
  encryption_type = var.encryption_type
  force_delete = var.force_delete
  scan_on_push = var.scan_on_push
  tags = var.tags
}

# ============================================================
# ALB
# ============================================================

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_ids
  security_groups = module.sg.alb
  deregistration_delay = var.deregistration_delay
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2 = var.enable_http2
  load_balancer_type = var.load_balancer_type
  certificate_arn = var.certificate_arn
  ssl_policy = var.ssl_policy
  tags = var.tags
}

# ============================================================
# IAM
# ============================================================

module "iam" {
  source = "./modules/iam"
  secret_arn = module.secret.secret_arn
  tags = var.tags
}

# ============================================================
# RDS
# ============================================================

module "rds" {
  source = "./modules/rds"
  postgres_subnets = module.vpc.data_private_ids
  postgres_sg = module.sg.postgres
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_port = var.db_port
  apply_immediately = var.apply_immediately
  deletion_protection = var.deletion_protection
  multi_az = var.multi_az
  skip_final_snapshot = var.skip_final_snapshot
  tags = var.tags
}

# ============================================================
# Secrets Manager
# ============================================================

module "secret" {
  source = "./modules/secret"
  db_name = module.rds.rds_name
  db_username = var.db_username
  db_password = var.db_password
  access_token_secret = var.access_token_secret
  refresh_token_secret = var.refresh_token_secret
  tags = var.tags
}

# ============================================================
# REDIS
# ============================================================

module "redis" {
  source = "./modules/redis"
  redis_subnets = module.vpc.data_private_ids
  redis_sg = module.sg.redis
  apply_immediately = var.apply_immediately
  node_type = var.node_type
  num_cache_nodes = var.num_cache_nodes
  tags = var.tags
}

# ============================================================
# ECS
# ============================================================

module "ecs" {
  source = "./modules/ecs"
  vpc_id = module.vpc.vpc_id

  nestjs_subnets = module.vpc.app_private_ids
  nextjs_subnets = module.vpc.app_private_ids

  nestjs_security_groups = module.sg.nestjs
  nextjs_security_groups = module.sg.nextjs
  nextjs_target_group_arn = module.alb.nextjs_target_group_arn

  app_secrets_arn = module.secret.secret_arn

  project = var.project
  node_env = var.node_env
  db_host = module.rds.rds_endpoint
  db_name = module.rds.rds_name
  db_port = module.rds.rds_port

  redis_host = module.redis.redis_endpoint
  redis_port = module.redis.redis_port

  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  nestjs_task_role_arn = module.iam.nestjs_task_role_arn
  nextjs_task_role_arn = module.iam.nextjs_task_role_arn

  network_mode = var.network_mode
  launch_type = var.launch_type
  skip_destroy = var.skip_destroy
  requires_compatibilities = var.requires_compatibilities

  nest_port = var.nest_port
  nestjs_image = module.ecr.nestjs_ecr
  nestjs_image_tag = "latest"

  nestjs_cpu = var.nestjs_cpu
  nestjs_memory = var.nestjs_memory
  nestjs_desired_count = var.nestjs_desired_count


  next_port = var.next_port
  nextjs_image = module.ecr.nextjs_ecr
  nextjs_image_tag = "latest"
  nextjs_cpu = var.nextjs_cpu
  nextjs_memory = var.nextjs_memory
  nextjs_desired_count = var.nextjs_desired_count

  tags = var.tags
}