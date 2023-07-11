############CREATING A ECS CLUSTER#############

resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "service"
  cpu                      = 512
  memory                   = 2048
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "busybox",
      "image"     : "543512271426.dkr.ecr.us-east-1.amazonaws.com/busybox:latest",
      "cpu"       : 512,
      "memory"    : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "service" {
  name             = "ecs-service"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.task.id
  desired_count    = 2
}


resource "aws_launch_template" "ecs-template" {
  name_prefix          = "ecs-template"
  image_id      = "ami-0507dff4275d8dd6d"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "ecs_asg" {
    name                      = "ecs-asg"
    availability_zones        = ["us-east-1a"]
    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 10
    launch_template {
         id = aws_launch_template.ecs-template.id
         version = "$Latest"
      }
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = "aws_iam_role.ecs_agent.name"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}
