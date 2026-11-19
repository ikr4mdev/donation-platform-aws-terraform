output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "nextjs_task_role_arn" {
  value = aws_iam_role.nextjs_task_role.arn
}

output "nestjs_task_role_arn" {
  value = aws_iam_role.nestjs_task_role.arn
}