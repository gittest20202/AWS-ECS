resource "aws_ecs_cluster" "dev" {
  lifecycle {
    create_before_destroy = true
  }

  name = "dev"

  tags = {
    Env  = "dev"
    Name = "dev"
  }
}

resource "aws_ecs_task_definition" "ecstskdef" {
  container_definitions = jsonencode([
    {
      name      = "blog"
      image     = "543512271426.dkr.ecr.us-east-1.amazonaws.com/blog:latest"
      cpu       = 1024
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
])
  family                   = "blog"
  memory                   = 500
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
}


resource "aws_ecs_service" "ecssvc" {
  cluster                 = aws_ecs_cluster.dev.id
  depends_on              = [aws_iam_role_policy_attachment.ecs]
  desired_count           = 1
  enable_ecs_managed_tags = true
  force_new_deployment    = true

  load_balancer {
    target_group_arn = aws_alb_target_group.awstg.arn
    container_name   = "blog"
    container_port   = 8080
  }

  name            = "blog"
  task_definition = "${aws_ecs_task_definition.ecstskdef.family}:${aws_ecs_task_definition.ecstskdef.revision}"
}
