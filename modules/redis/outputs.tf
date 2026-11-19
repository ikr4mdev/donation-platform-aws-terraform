# ==============================================================
# redis endpoint
# ==============================================================

output "redis_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

# ==============================================================
# redis port
# ==============================================================

output "redis_port" {
  value = aws_elasticache_replication_group.redis.port
}