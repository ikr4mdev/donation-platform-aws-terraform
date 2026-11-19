# ============================================================
# ECS TASK EXECUTION ROLE
# ============================================================

resource "aws_iam_role" "ecs_execution_role" {
  name = "${terraform.workspace}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    {
      Name = "${terraform.workspace}-ecs-execution-role"
    },

    var.tags,
  )
}

resource "aws_iam_role_policy_attachment" "ecs_execution_managed" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ============================================================
# NEXT.JS TASK ROLE
# ============================================================

resource "aws_iam_role" "nextjs_task_role" {
  name = "${terraform.workspace}-nextjs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    {
      Name = "${terraform.workspace}-nextjs-task-role"
    },

    var.tags,
  )
}

# ============================================================
# NESTJS TASK ROLE
# ============================================================

resource "aws_iam_role" "nestjs_task_role" {
  name = "${terraform.workspace}-nestjs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    {
      Name = "${terraform.workspace}-nestjs-task-role"
    },

    var.tags,
  )
}

# ============================================================
# SECRET MANAGER ROLE
# ============================================================

resource "aws_iam_policy" "ecs_secrets_manager" {
  name        = "${terraform.workspace}-ecs-secrets-manager"
  description = "Allow ECS tasks to retrieve application secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.secret_arn
      }
    ]
  })

  tags = merge(
    {
      Name = "${terraform.workspace}-ecs-secrets-manager"
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "ecs_secrets_manager" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_secrets_manager.arn
}