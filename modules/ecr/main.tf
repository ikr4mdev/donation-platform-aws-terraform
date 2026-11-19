# ==============================================================
# NEXT JS ECR REPOSITORY
# ==============================================================

resource "aws_ecr_repository" "nextjs_ecr" {
  name                 = "nextjs_ecr"
  image_tag_mutability = var.image_tag_mutability

  force_delete = var.force_delete

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(
    {
        Name = "${terraform.workspace}-nextjs-ecr"
    },
    var.tags
  )
}

# ==============================================================
# NEXT JS ECR LIFECYCLE POLICY
# ==============================================================

resource "aws_ecr_lifecycle_policy" "nextjs_ecr_policy" {
  repository = aws_ecr_repository.nextjs_ecr.name

  policy = jsonencode({
    rules = [
      # ============================================================
      # Older than 14 days → DELETE
      # ============================================================
      {
        rulePriority = 1
        description  = "Expire untagged images older than 14 days"

        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }

        action = {
          type = "expire"
        }
      },

      # ============================================================
      # Keep newest 10 -> Older tagged images → DELETE
      # ============================================================
      {
        rulePriority = 2
        description  = "Keep only the last 10 tagged images"

        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["*"]
          countType      = "imageCountMoreThan"
          countNumber    = 10
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ==============================================================
# NEST JS ECR REPOSITORY
# ==============================================================

resource "aws_ecr_repository" "nestjs_ecr" {
  name                 = "nestjs_ecr"
  image_tag_mutability = var.image_tag_mutability

  force_delete = var.force_delete

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(
    {
        Name = "${terraform.workspace}-nestjs-ecr"
    },
    var.tags
  )
}

# ==============================================================
# NEST JS ECR LIFECYCLE POLICY
# ==============================================================

resource "aws_ecr_lifecycle_policy" "nestjs_ecr_policy" {
  repository = aws_ecr_repository.nestjs_ecr.name

  policy = jsonencode({
    rules = [
      # ============================================================
      # Older than 14 days → DELETE
      # ============================================================
      {
        rulePriority = 1
        description  = "Expire untagged images older than 14 days"

        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }

        action = {
          type = "expire"
        }
      },

      # ============================================================
      # Keep newest 10 -> Older tagged images → DELETE
      # ============================================================
      {
        rulePriority = 2
        description  = "Keep only the last 10 tagged images"

        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["*"]
          countType      = "imageCountMoreThan"
          countNumber    = 10
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}