module "ecs" {
    source = "./ECS"
    vpc_id = "vpc-04c7dd1feac34dbe3"
    subnet_id = ["subnet-0a3ff8a6ffa4f8059", "subnet-0dd98cc3b2a8e20dc"]
    log_group_name = "/ecs/cfl-project"
    cluster_name = "cfl-cluster"
    cluster_service_name = "cfl-service"
    cluster_task_service_name = "cfl-task-service"
    execution_role_arn = "arn:aws:iam::884390772196:role/ecsTaskExecutionRole"
    image_id = "884390772196.dkr.ecr.us-east-1.amazonaws.com/myapp:latest"
}

module "ecs_autoscaling" {
  source       = "./ASG"
  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
}