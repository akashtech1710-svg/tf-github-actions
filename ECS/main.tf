data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}

resource "aws_cloudwatch_log_group" "cfl_log_group" {
  name = var.log_group_name
}

resource "aws_security_group" "cfl_sg" {
    vpc_id = data.aws_vpc.existing_vpc.id
    name = "cfl-security-group"

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      "env" = "cfl-project" 
    }
}

resource "aws_ecs_task_definition" "cfl_task_definition" {
  family = var.cluster_task_service_name
  network_mode = "awsvpc"
  memory = "512"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = var.execution_role_arn
  container_definitions = jsonencode([
    {
       name = "flask-app-container"
       image = var.image_id
       cpu = 256
       memory = 512
       portMappings = [
        {
          containerPort = 5000
          hostPort = 5000
          protocol = "tcp"
        }
       ]
       logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.cfl_log_group.name
          "awslogs-region" = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
       }

    }
  ])

  cpu = "256"
}

resource "aws_ecs_cluster" "cfl_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_service" "cfl_service" {
  name = var.cluster_service_name
  cluster = aws_ecs_cluster.cfl_cluster.id
  task_definition = aws_ecs_task_definition.cfl_task_definition.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [var.subnet_id[0], var.subnet_id[1]]
    security_groups = [aws_security_group.cfl_sg.id]
    assign_public_ip = true
  }
  
}