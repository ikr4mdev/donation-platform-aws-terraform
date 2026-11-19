output "nextjs_log_group_name" {
  value = aws_cloudwatch_log_group.nextjs.name
}

output "nestjs_log_group_name" {
  value = aws_cloudwatch_log_group.nestjs.name
}

output "nextjs_log_group_arn" {
  value = aws_cloudwatch_log_group.nextjs.arn
}

output "nestjs_log_group_arn" {
  value = aws_cloudwatch_log_group.nestjs.arn
}