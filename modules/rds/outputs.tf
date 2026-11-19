# ============================================================
# RDS ENDPOINT OUTPUTS
# ============================================================

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.db.address
}

# ============================================================
# RDS NAME OUTPUTS
# ============================================================

output "rds_name" {
  description = "RDS PostgreSQL db name"
  value       = aws_db_instance.db.db_name
}

# ============================================================
# RDS PORT OUTPUTS
# ============================================================

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = aws_db_instance.db.port
}