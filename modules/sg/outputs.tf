# ==============================================================
# ALB SG ID OUTPUTS
# ==============================================================

output "alb" {
  description = "ALB SG ID"
  value = aws_security_group.alb_sg.id
}

# ==============================================================
# NEXTJS SG ID OUTPUTS
# ==============================================================

output "nextjs" {
  description = "NEXTJS SG ID"
  value = aws_security_group.nextjs_sg.id
}

# ==============================================================
# NESTJS SG ID OUTPUTS
# ==============================================================

output "nestjs" {
  description = "NESTJS SG ID"
  value = aws_security_group.nestjs_sg.id
}

# ==============================================================
# POSTGRES SG ID OUTPUTS
# ==============================================================

output "postgres" {
  description = "POSTGRES SG ID"
  value = aws_security_group.postgres_sg.id
}

# ==============================================================
# REDIS SG ID OUTPUTS
# ==============================================================

output "redis" {
  description = "REDIS SG ID"
  value = aws_security_group.redis_sg.id
}
