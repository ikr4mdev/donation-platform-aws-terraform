# ============================================================
# NEXT JS CLOUDWATCH
# ============================================================

resource "aws_cloudwatch_log_group" "nextjs" {
  name              = "/${terraform.workspace}/nextjs"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${terraform.workspace}-nextjs"
    Environment = terraform.workspace
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ============================================================
# NEST JS CLOUDWATCH
# ============================================================

resource "aws_cloudwatch_log_group" "nestjs" {
  name              = "/${terraform.workspace}/nestjs"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${terraform.workspace}-nestjs"
    Environment = terraform.workspace
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}