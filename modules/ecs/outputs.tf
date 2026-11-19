# ==============================================================
# ECS cluster ID/ARN
# ==============================================================

output "ecs_cluster_id" {
  value       = aws_ecs_cluster.cluster.id
  description = "The ID of the ECS cluster"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.cluster.arn
  description = "The ARN of the ECS cluster"
}

# ==============================================================
# Next.js service name/ID
# ==============================================================

output "nextjs_service_name" {
  value       = aws_ecs_service.nextjs_service.name
  description = "The name of the Next.js ECS service"
}

output "nextjs_service_id" {
  value       = aws_ecs_service.nextjs_service.id
  description = "The ID of the Next.js ECS service"
}

# ==============================================================
# NestJS service name/ID
# ==============================================================

output "nestjs_service_name" {
  value       = aws_ecs_service.nestjs_service.name
  description = "The name of the NestJS ECS service"
}

output "nestjs_service_id" {
  value       = aws_ecs_service.nestjs_service.id
  description = "The ID of the NestJS ECS service"
}

# ==============================================================
# Next.js task definition ARN
# ==============================================================

output "nextjs_task_definition_arn" {
  value       = aws_ecs_task_definition.nextjs_td.arn
  description = "The ARN of the Next.js ECS task definition"
}

# ==============================================================
# NestJS task definition ARN
# ==============================================================

output "nestjs_task_definition_arn" {
  value       = aws_ecs_task_definition.nestjs_td.arn
  description = "The ARN of the NestJS ECS task definition"
}