# ==============================================================
# NEXT JS ECR OUTPUTS
# ==============================================================

output "nextjs_ecr" {
  description = "Next.js ECR repository URL"
  value = aws_ecr_repository.nextjs_ecr.repository_url
}

# ==============================================================
# NEST JS ECR OUTPUTS
# ==============================================================

output "nestjs_ecr" {
  description = "NestJS ECR repository URL"
  value = aws_ecr_repository.nestjs_ecr.repository_url
}