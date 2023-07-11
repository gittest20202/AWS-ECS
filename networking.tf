data "aws_vpc" "ecs-vpc" {
  filter {
    name   = "tag:Name"
    values = ["ecs"]
  }
}

data "aws_subnet" "ecs-subnet" {
  filter {
    name   = "tag:Name"
    values = ["ecs-1"]
  }
}
data "aws_subnet" "ecs-subnet1" {
  filter {
    name   = "tag:Name"
    values = ["ecs-2"]
  }
}

data "aws_security_group" "ecs-sg" {
  filter {
    name   = "tag:Name"
    values = ["ecs"]
  }
}
