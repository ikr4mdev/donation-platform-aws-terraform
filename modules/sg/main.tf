# ==============================================================
# ALB SG
# ==============================================================

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Application Load Balancer security group"
  vpc_id      = var.vpc_id

  tags = merge(
    {
        Name = "${terraform.workspace}-alb-sg"
    },
    var.tags
  )
}

# ==============================================================
# NEXT JS SG
# ==============================================================

resource "aws_security_group" "nextjs_sg" {
  name        = "nextjs_sg"
  description = "Nextjs security group"
  vpc_id      = var.vpc_id

  tags = merge(
    {
        Name = "${terraform.workspace}-nextjs-sg"
    },
    var.tags
  )
}

# ==============================================================
# NEST JS SG
# ==============================================================

resource "aws_security_group" "nestjs_sg" {
  name        = "nestjs_sg"
  description = "Nestjs security group"
  vpc_id      = var.vpc_id

  tags = merge(
    {
        Name = "${terraform.workspace}-nestjs-sg"
    },
    var.tags
  )
}

# ==============================================================
# POSTGRES JS SG
# ==============================================================

resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Postgres security group"
  vpc_id      = var.vpc_id

  tags = merge(
    {
        Name = "${terraform.workspace}-postgres-sg"
    },
    var.tags
  )
}

# ==============================================================
# REDIS SG
# ==============================================================

resource "aws_security_group" "redis_sg" {
  name        = "redis_sg"
  description = "Redis security group"
  vpc_id      = var.vpc_id

  tags = merge(
    {
        Name = "${terraform.workspace}-redis-sg"
    },
    var.tags
  )
}

# ==============================================================
# ALB INBOUND - HTTP
# ==============================================================

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb_sg.id
  description = "HTTP from internet"

  cidr_ipv4 = var.anywhere_cidr
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

# ==============================================================
# ALB INBOUND - HTTPS
# ==============================================================

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.alb_sg.id
  description = "HTTPS from internet"

  cidr_ipv4 = var.anywhere_cidr
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

# ==============================================================
# ALB OUTBOUND - NEXT JS
# ==============================================================

resource "aws_vpc_security_group_egress_rule" "alb_to_next" {
  security_group_id = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.nextjs_sg.id
  description = "To next js"

  from_port = 3000
  to_port = 3000
  ip_protocol = "tcp"
}

# ==============================================================
# NEXT JS INBOUND - ALB
# ==============================================================

resource "aws_vpc_security_group_ingress_rule" "next_inbound" {
  security_group_id = aws_security_group.nextjs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id

  from_port = 3000
  to_port = 3000
  ip_protocol = "tcp"
}

# ==============================================================
# NEXT JS OUTBOUND - NEST JS
# ==============================================================

resource "aws_vpc_security_group_egress_rule" "next_to_nest" {
  security_group_id = aws_security_group.nextjs_sg.id
  referenced_security_group_id = aws_security_group.nestjs_sg.id

  from_port = 4000
  to_port = 4000
  ip_protocol = "tcp"
}

# ======================================================================
# NEXT.JS OUTBOUND -> INTERNET
# ======================================================================

resource "aws_vpc_security_group_egress_rule" "next_to_internet" {
  security_group_id = aws_security_group.nextjs_sg.id

  description = "Next.js outbound HTTPS"
  cidr_ipv4   = var.anywhere_cidr
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


# ==============================================================
# NEST JS INBOUND - NEXT JS
# ==============================================================

resource "aws_vpc_security_group_ingress_rule" "nest_inbound" {
  security_group_id = aws_security_group.nestjs_sg.id
  referenced_security_group_id = aws_security_group.nextjs_sg.id

  from_port = 4000
  to_port = 4000
  ip_protocol = "tcp"
}

# ======================================================================
# NEST.JS OUTBOUND -> INTERNET
# ======================================================================

resource "aws_vpc_security_group_egress_rule" "nest_to_internet" {
  security_group_id = aws_security_group.nestjs_sg.id

  description = "NestJS outbound HTTPS"
  cidr_ipv4   = var.anywhere_cidr
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

# ==============================================================
# NEST JS OUTBOUND - POSTGRES OR REDIS
# ==============================================================

resource "aws_vpc_security_group_egress_rule" "nest_to_postgres" {
  security_group_id = aws_security_group.nestjs_sg.id
  referenced_security_group_id = aws_security_group.postgres_sg.id

  from_port = 5432
  to_port = 5432
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "nest_to_redis" {
  security_group_id = aws_security_group.nestjs_sg.id
  referenced_security_group_id = aws_security_group.redis_sg.id

  from_port = 6379
  to_port = 6379
  ip_protocol = "tcp"
}

# ==============================================================
# POSTGRES INBOUND - NEST JS
# ==============================================================

resource "aws_vpc_security_group_ingress_rule" "postgres_inbound" {
  security_group_id = aws_security_group.postgres_sg.id
  referenced_security_group_id = aws_security_group.nestjs_sg.id

  from_port = 5432
  to_port = 5432
  ip_protocol = "tcp"
}

# ==============================================================
# REDIS INBOUND - NEST JS
# ==============================================================

resource "aws_vpc_security_group_ingress_rule" "redis_inbound" {
  security_group_id = aws_security_group.redis_sg.id
  referenced_security_group_id = aws_security_group.nestjs_sg.id

  from_port = 6379
  to_port = 6379
  ip_protocol = "tcp"
}