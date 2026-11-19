# ==============================================================
# DB subnets
# ==============================================================

resource "aws_db_subnet_group" "db_subnet" {
  name       = "${terraform.workspace}-db-subnet-group"
  subnet_ids = var.postgres_subnets

  tags = merge(
    {
      Name = "${terraform.workspace}-db-subnet-group"
    },

    var.tags,
  )
}


# ==============================================================
# DB instance
# ==============================================================

resource "aws_db_instance" "db" {
  identifier = "${terraform.workspace}-donation-db"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  engine               = "postgres"
  engine_version       = "17"
  instance_class       = "db.t3.micro"


  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  port                 = var.db_port

  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  backup_retention_period = 7
  backup_window      = "03:00-04:00"
  maintenance_window = "sun:04:00-sun:05:00"

  multi_az = var.multi_az


  storage_encrypted = true

  vpc_security_group_ids = var.postgres_sg

  deletion_protection = var.deletion_protection

  apply_immediately = var.apply_immediately

  skip_final_snapshot  = var.skip_final_snapshot

  tags = merge(
    {
      Name = "${terraform.workspace}-db-instance"
    },

    var.tags,
  )
}