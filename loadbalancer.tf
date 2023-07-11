resource "aws_lb" "ecs-lb" {
  name            = "ecs-lb"
  subnets         = [data.aws_subnet.ecs-subnet.id, data.aws_subnet.ecs-subnet1.id]
  security_groups = [data.aws_security_group.ecs-sg.id]
}

resource "aws_lb_target_group" "ecs-tg" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.ecs-vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "ecs-lin" {
  load_balancer_arn = aws_lb.ecs-lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs-tg.id
    type             = "forward"
  }
}
