# ==============================================================
# REDIS SUBNETS GROUP
# ==============================================================

resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "${terraform.workspace}-redis"
  subnet_ids = var.redis_subnets

  tags = merge(
    {
        Name = "${terraform.workspace}-redis-subnets"
    },
    var.tags
  )
}

# ==============================================================
# Elasticache Replication Group
# ==============================================================

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${terraform.workspace}-redis"
  description = "Valkey replication group for ${terraform.workspace}"

  engine = "valkey"
  node_type = var.node_type
  port = 6379

  num_cache_clusters = var.num_cache_nodes

  subnet_group_name = aws_elasticache_subnet_group.redis_subnets.name
  security_group_ids = var.redis_sg

  automatic_failover_enabled = true
  multi_az_enabled            = true

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  apply_immediately = var.apply_immediately

  tags = merge(
    {
      Name = "${terraform.workspace}-redis"
    },
    var.tags
  )
}