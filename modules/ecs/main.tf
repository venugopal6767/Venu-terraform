# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "main-ecs-cluster"
}

resource "aws_ecs_task_definition" "service_80_task" {
  family                   = "service-80-task"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "service-80-container"
    image     = "wordpress:latest"
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
  }])
}

resource "aws_ecs_task_definition" "service_3000_task" {
  family                   = "service-3000-task"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "service-3000-container"
    image     = "241533153772.dkr.ecr.us-east-1.amazonaws.com/custom-image:latest"
    essential = true
    portMappings = [
      {
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      }
    ]
  }])
}

# ECS Service for Service 80 (nginx:latest on port 80)
resource "aws_ecs_service" "service_80" {
  name            = "wordpress"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service_80_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet_1.id, var.private_subnet_2.id]
    security_groups = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service_80_target_group.arn
    container_name   = "service-80-container"
    container_port   = 80
  }
}

# ECS Service for Service 3000 (microservice: on port 3000)
resource "aws_ecs_service" "service_3000" {
  name            = "microservice"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service_3000_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet_1.id, var.private_subnet_2.id]
    security_groups = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service_3000_target_group.arn
    container_name   = "service-3000-container"
    container_port   = 3000
  }
}
