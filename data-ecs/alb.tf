resource "aws_security_group" "sgalb" {
  description = "security-group-alb"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  name = "security-group-alb"

  tags = {
    Env  = "dev"
    Name = "security-group-alb"
  }

  vpc_id = data.aws_vpc.ecs.id
}

resource "aws_alb" "awsalb" {
  name            = "alb"
  security_groups = [aws_security_group.sgalb.id]

  subnets = [
    data.aws_subnet.publica.id,
    data.aws_subnet.publicb.id,
  ]
}

resource "aws_alb_target_group" "awstg" {
  health_check {
    path = "/"
  }

  name     = "alb-target-group"
  port     = 8080
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  vpc_id = data.aws_vpc.ecs.id
}
