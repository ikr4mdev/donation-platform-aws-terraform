# ==============================================================
# VPC ID OUTPUTS
# ==============================================================

output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.main.id
}

# ==============================================================
# PUBLIC SUBNETS IDS OUTPUTS
# ==============================================================

output "public_ids" {
  description = "Public subnet ids"
  value = aws_subnet.public_subnets[*].id
}

# ==============================================================
# APPLICATION PRIVATE SUBNETS IDS OUTPUTS
# ==============================================================

output "app_private_ids" {
  description = "Application private subnet ids"
  value = aws_subnet.app_private_subnets[*].id
}

# ==============================================================
# DATA PRIVATE SUBNETS IDS OUTPUTS
# ==============================================================

output "data_private_ids" {
  description = "Data private subnet ids"
  value = aws_subnet.data_private_subnets[*].id
}