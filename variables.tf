# ==============================================================
# VPC
# ==============================================================
# ==============================================================
# VPC CIDR
# ==============================================================

variable "vpc_cidr" {
  description = "VPC CIDR"
  type = string
}

# ==============================================================
# VPC DNS
# ==============================================================

variable "enable_dns_support" {
  description = "Enable DNS support"
  type = bool
}

variable "enable_dns_hostname" {
  description = "Enable DNS hostnames"
  type = bool
}

# ==============================================================
# Subnets with 3 Availability Zones
# Public subnets
# ==============================================================

variable "public_subnets" {
  description = "Public subnets"
  type = list(string)
}

# ==============================================================
# Private application subnets
# ==============================================================

variable "app_private_subnets" {
  description = "Application private subnets"
  type = list(string)
}

# ==============================================================
# Private database/cache subnets
# ==============================================================

variable "data_private_subnets" {
  description = "Data private subnets"
  type = list(string)
}


# ==============================================================
# SECURITY GROUPS
# ==============================================================
# ==============================================================
# Force Delete
# ==============================================================

variable "force_delete" {
  description = "Delete repo even if it contains images"
  type        = bool
}

# ==============================================================
# Encryption Type
# ==============================================================

variable "encryption_type" {
  description = "AES256 or KMS"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Must be AES256 or KMS."
  }
}

# ==============================================================
# Scan On Push
# ==============================================================

variable "scan_on_push" {
  type        = bool
}


# ==============================================================
# ALB
# ==============================================================
# ==============================================================
# Application Load Balancer
# ==============================================================

variable "load_balancer_type" {
  type = string
  default = "application"
}

# ==============================================================
# PUBLIC SUBNETS
# ==============================================================

variable "public_subnets" {
  description = "Public subnets ids"
  type = list(string)
}

# ==============================================================
# Enable Deletion Protection for dev false pro true
# ==============================================================

variable "enable_deletion_protection" {
  type = bool
  default = true
}

# ==============================================================
# Enable Http2
# ==============================================================

variable "enable_http2" {
  type = bool
  default = true
}

# ==============================================================
# Deregistration Delay
# ==============================================================

variable "deregistration_delay" {
  type = string
}

# ==============================================================
# ssl policy
# ==============================================================

variable "ssl_policy" {
  type = string
}

# ==============================================================
# certificate_arn
# ==============================================================

variable "certificate_arn" {
  type = string
}

# ==============================================================
# RDS
# ==============================================================
# ==============================================================
# DB
# ==============================================================

variable "db_name"          { type = string }
variable "db_username"      { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_port" {
  type    = number
  default = 5432
}

# ==============================================================
# Deletion Protection
# ==============================================================

variable "deletion_protection" {
  type = bool
}

# ==============================================================
# Apply Immediately
# ==============================================================

variable "apply_immediately" {
  type = bool
}

# ==============================================================
# Multi AZs
# ==============================================================

variable "multi_az" {
  type    = bool
  default = false
}

# ==============================================================
# skip_final_snapshot
# ==============================================================

variable "skip_final_snapshot" {
  type    = bool
  default = false
}

# ==============================================================
# TOKENS
# ==============================================================

variable "access_token_secret" {
  type = string
  sensitive = true
}
variable "refresh_token_secret" {
  type = string
  sensitive = true
}

# ==============================================================
# REDIS
# ==============================================================
# ==============================================================
# Num Cache Nodes
# ==============================================================

variable "num_cache_nodes" {
  type    = number
  default = 2

  validation {
    condition     = var.num_cache_nodes >= 2
    error_message = "Number of cache nodes must be at least 1."
  }
}

# ==============================================================
# NODE TYPE
# ==============================================================

variable "node_type" {
  type    = string
  default = "cache.t4g.micro"
}

# ==============================================================
# NODE ENV
# ==============================================================

variable "node_env" {
  description = "node evn"
  type = string
}

variable "next_port" {
  type    = string
  default = "3000"
}

variable "nest_port" {
  type    = string
  default = "4000"
}

# ==============================================================
# NEXT JS CPU
# ==============================================================

variable "nextjs_cpu" {
  type = string
  default = "256"
}

# ==============================================================
# NEST JS CPU
# ==============================================================

variable "nestjs_cpu" {
  type = string
  default = "256"
}

# ==============================================================
# NEXT JS MEMORY
# ==============================================================

variable "nextjs_memory" {
  type = string
  default = "512"
}

# ==============================================================
# NEST JS MEMORY
# ==============================================================

variable "nestjs_memory" {
  type = string
  default = "512"
}

# ==============================================================
# NETWORK MODE
# ==============================================================

variable "network_mode" {
  type = string
  default = "awsvpc"
}

# ==============================================================
# Requires Compatibilities
# ==============================================================

variable "requires_compatibilities" {
  type = list(string)
  default = [ "FARGATE" ]
}

# ==============================================================
# Skip Destroy
# ==============================================================

variable "skip_destroy" {
  type = bool
  default = false
}

# ==============================================================
# Launch Type
# ==============================================================

variable "launch_type" {
  type = string
  default = "FARGATE"
}

# ==============================================================
# NEXT JS Desired Count
# ==============================================================

variable "nextjs_desired_count" {
  type = number
  default = 2

  validation {
    condition     = var.nextjs_desired_count >= 1
    error_message = "Desired count must be at least 1."
  }
}

# ==============================================================
# NEST JS Desired Count
# ==============================================================

variable "nestjs_desired_count" {
  type = number
  default = 2

  validation {
    condition     = var.nestjs_desired_count >= 1
    error_message = "Desired count must be at least 1."
  }
}


# ==============================================================
# PROJECT
# ==============================================================

variable "project" {
  description = "project name"
  type = string
}

# ==============================================================
# FROM ANYWHERE
# ==============================================================

variable "anywhere" {
  description = "From anywhere"
  type = string
}

# ==============================================================
# APP TAGS
# ==============================================================

variable "tags" {
  type = map(string)
}

variable "image_tag_mutability" {
  description = "MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Must be MUTABLE or IMMUTABLE."
  }
}