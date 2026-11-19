# ==============================================================
# VPC ID
# ==============================================================

variable "vpc_id" {
  type = string
}

# ==============================================================
# IAM Roles
# ==============================================================
variable "ecs_execution_role_arn" { type = string }
variable "nextjs_task_role_arn"   { type = string }
variable "nestjs_task_role_arn"   { type = string }

# ==============================================================
# APP TAGS
# ==============================================================

variable "project" {
  type = string
}

# ==============================================================
# NEXT JS REPO
# ==============================================================

variable "nextjs_image" {
  type = string
}

# ==============================================================
# NEST JS REPO
# ==============================================================

variable "nestjs_image" {
  type = string
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
# NEXT JS TARGET GROUP ARN
# ==============================================================

variable "nextjs_target_group_arn" {
  description = "ARN of the Next.js target group"
  type        = string
}

# ==============================================================
# NEXT JS SUBNETS
# ==============================================================

variable "nextjs_subnets" {
  description = "List of subnets for the Next.js service"
  type        = list(string)
}

# ==============================================================
# NEXT JS SECURITY GROUPS
# ==============================================================

variable "nextjs_security_groups" {
  type        = list(string)
  default     = []
}


# ==============================================================
# NEST JS SUBNETS
# ==============================================================

variable "nestjs_subnets" {
  description = "List of subnets for the Nest.js service"
  type        = list(string)
}

# ==============================================================
# NEST JS SECURITY GROUPS
# ==============================================================

variable "nestjs_security_groups" {
  type        = list(string)
  default     = []
}

# ==============================================================
# Launch Type
# ==============================================================

variable "launch_type" {
  type = string
  default = "FARGATE"
}

# ==============================================================
# NEXT JS IMAGE TAG
# ==============================================================

variable "nextjs_image_tag" {
  type = string
}

# ==============================================================
# NEST JS IMAGE TAG
# ==============================================================

variable "nestjs_image_tag" {
  type = string
}

# ==============================================================
# Environment
# ==============================================================

variable "node_env"      { type = string }

variable "db_name"          { type = string }
variable "db_host"          { type = string }
variable "db_port" {
  type    = string
  default = "5432"
}

variable "next_port" {
  type    = string
  default = "3000"
}

variable "nest_port" {
  type    = string
  default = "4000"
}

variable "redis_host"      { type = string }
variable "redis_port"      { type = string }

# ==============================================================
# APPLICATION SECRET
# ==============================================================

variable "app_secrets_arn" { type = string }

# ==============================================================
# APP TAGS
# ==============================================================

variable "tags" {
  type = map(string)
}