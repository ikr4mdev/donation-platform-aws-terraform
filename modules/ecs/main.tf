# ==============================================================
# ECS CLUSTER
# ==============================================================

resource "aws_ecs_cluster" "cluster" {
  name = "${terraform.workspace}-cluster"

  tags = merge(
    {
      Name = "${terraform.workspace}-cluster"
    },

    var.tags,
  )
}

# ==============================================================
# Private DNS namespace
# ==============================================================

resource "aws_service_discovery_private_dns_namespace" "internal" {
  name        = "${terraform.workspace}.internal"
  description = "Private DNS namespace for ECS service discovery"
  vpc         = var.vpc_id

  tags = merge(
    {
      Name = "${terraform.workspace}-internal"
    },

    var.tags,
  )
}

# ==============================================================
# Registers a service inside that namespace
# ==============================================================

resource "aws_service_discovery_service" "nestjs" {
  name = "nestjs"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.internal.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name = "${terraform.workspace}-nestjs-discovery"
  }
}

# ==============================================================
# NEXT JS TASK DEFINITION
# ==============================================================

resource "aws_ecs_task_definition" "nextjs_td" {
  family = "${var.project}-nextjs"
  network_mode = var.network_mode # Specifies the Docker networking mode to use for the containers in the task. "awsvpc" mode provides each task with its own elastic network interface (ENI) and a private IP address, allowing for better isolation and security.
  requires_compatibilities = var.requires_compatibilities # Specifies that the task definition is compatible with Fargate

  cpu = var.nextjs_cpu
  memory = var.nextjs_memory

  execution_role_arn = var.ecs_execution_role_arn # Specifies the ARN of the IAM role that the Amazon ECS container agent and Docker daemon can assume to make AWS API calls on your behalf. This role is used for tasks that require access to AWS services, such as pulling images from Amazon ECR or writing logs to Amazon CloudWatch.
  task_role_arn = var.nextjs_task_role_arn # Specifies the ARN of the IAM role that containers in this task can assume. This role is used for tasks that require access to AWS services, such as accessing secrets from AWS Secrets Manager or reading from Amazon S3.

  skip_destroy = var.skip_destroy

  container_definitions = jsonencode([{
    name = "nextjs-container" # Name of the container in the task definition
    image = "${var.nextjs_image}:${var.nextjs_image_tag}" # Use the specified image tag from the Next.js repository
    essential = true # Indicates that if this container fails or stops, the task should be considered failed

    portMappings = [
      {
        containerPort = var.next_port # Port on which the container listens
        hostPort      = var.next_port # Port on the host to which the container port is mapped
        protocol      = "tcp" # Protocol used for the port mapping (TCP in this case)
      }
    ]

    environment = [
      {
        name = "NODE_ENV"
        value = var.node_env
      },
      {
        name = "PORT"
        value = var.next_port
      },
      {
        name = "NEST_API"
        value = "http://nestjs.${terraform.workspace}.internal:${var.nest_port}"
      }
    ]

    secrets = [
      {
        name = "ACCESS_TOKEN_SECRET"
        valueFrom = "${var.app_secrets_arn}:ACCESS_TOKEN_SECRET::"
      },
    ]

    healthCheck = {
        command     = ["CMD-SHELL", "wget -qO- http://localhost:${var.next_port}/ || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
  }])

  tags = merge(
    {
      Name = "${terraform.workspace}-nextjs-task"
    },

    var.tags,
  )
}

# ==============================================================
# NEXT JS SERVICE
# ==============================================================

resource "aws_ecs_service" "nextjs_service" {
  name            = "nextjs" # Name of the ECS service
  cluster         = aws_ecs_cluster.cluster.id # Use the ECS cluster ID from the cluster resource
  task_definition = aws_ecs_task_definition.nextjs_td.arn # Use the task definition ARN from the nextjs_td resource
  desired_count   = var.nextjs_desired_count # Use the nextjs_desired_count variable to specify the number of tasks to run
  launch_type = var.launch_type # Use the launch_type variable to specify the launch type (FARGATE or EC2)

  deployment_minimum_healthy_percent = 100 # Ensures that the service maintains 100% of the desired count during deployments
  deployment_maximum_percent = 200 # Allows for rolling updates with zero downtime

  platform_version = "LATEST" # Use the latest platform version for Fargate

  health_check_grace_period_seconds = 60 # 60 seconds grace period for health checks

  network_configuration {
    subnets = var.nextjs_subnets
    security_groups = var.nextjs_security_groups
    assign_public_ip = false
  }

  deployment_circuit_breaker {
    enable = true # Enables the deployment circuit breaker to automatically roll back failed deployments
    rollback = true # Automatically roll back to the last known good state if a deployment fails
  }

  # iam_role        = aws_iam_role.foo.arn
  # depends_on      = [aws_iam_role_policy.foo]

  load_balancer {
    container_name = "nextjs-container" # Name of the container in the task definition to associate with the load balancer
    container_port = var.next_port # Port on which the container is listening
    target_group_arn = var.nextjs_target_group_arn # Use the target group ARN from the variable to associate the service with the load balancer
  }

  enable_execute_command = true # Enables ECS Exec for debugging and troubleshooting

  tags = merge(
    {
      Name = "${terraform.workspace}-nextjs-service"
    },
    var.tags,
  )
}

# ==============================================================
# NEST JS TASK DEFINITION
# ==============================================================

resource "aws_ecs_task_definition" "nestjs_td" {
  family = "${var.project}-nestjs"
  network_mode = var.network_mode
  requires_compatibilities = var.requires_compatibilities

  cpu = var.nestjs_cpu
  memory = var.nestjs_memory

  execution_role_arn = var.ecs_execution_role_arn
  task_role_arn = var.nestjs_task_role_arn

  skip_destroy = var.skip_destroy

  container_definitions = jsonencode([{
    name = "nestjs-container"
    image = "${var.nestjs_image}:${var.nestjs_image_tag}"
    essential = true

    portMappings = [{
      containerPort = var.nest_port # Port on which the container listens
      hostPort      = var.nest_port # Port on the host to which the container port is mapped
      protocol      = "tcp" # Protocol used for the port mapping (TCP in this case)
    }]


    environment = [
      {
          name  = "NODE_ENV"
          value = var.node_env
      },
      {
          name  = "DB_HOST"
          value = var.db_host
      },
      {
          name  = "DB_NAME"
          value = var.db_name
      },
      {
          name  = "DB_PORT"
          value = var.db_port
      },
      {
          name  = "PORT"
          value = var.nest_port
      },
      {
          name  = "REDIS_HOST"
          value = var.redis_host
      },
      {
          name  = "REDIS_PORT"
          value = var.redis_port
      },
    ]

    secrets = [
      {
        name      = "DB_PASSWORD"
        valueFrom = "${var.app_secrets_arn}:DB_PASSWORD::"
      },
      {
          name  = "DB_USERNAME"
          valueFrom = "${var.app_secrets_arn}:DB_USERNAME::"
      },
      {
        name      = "ACCESS_TOKEN_SECRET"
        valueFrom = "${var.app_secrets_arn}:ACCESS_TOKEN_SECRET::"
      },
      {
        name      = "REFRESH_TOKEN_SECRET"
        valueFrom = "${var.app_secrets_arn}:REFRESH_TOKEN_SECRET::"
      }
    ]

    healthCheck = {
      command     = ["CMD-SHELL", "wget -qO- http://localhost:${var.nest_port}/api/v1/ || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
  }])

  tags = merge(
    {
      Name = "${terraform.workspace}-nestjs-task"
    },

    var.tags,
  )
}

# ==============================================================
# NEST JS SERVICE
# ==============================================================

resource "aws_ecs_service" "nestjs_service" {
  name            = "nestjs"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.nestjs_td.arn
  desired_count   = var.nestjs_desired_count
  launch_type = var.launch_type

  network_configuration {
    subnets = var.nestjs_subnets
    security_groups = var.nestjs_security_groups
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.nestjs.arn # Use the service discovery service ARN to register the Nest.js service
  }

  health_check_grace_period_seconds = 60

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  enable_execute_command = true # ECS Exec for debugging

  tags = merge(
    {
      Name = "${terraform.workspace}-nestjs-service"
    },

    var.tags,
  )
}