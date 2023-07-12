resource "aws_alb_listener" "alblsnr" {
  default_action {
    target_group_arn = aws_alb_target_group.awstg.arn
    type             = "forward"
  }

  load_balancer_arn = aws_alb.awsalb.arn
  port              = 80
  protocol          = "HTTP"
}
resource "aws_autoscaling_group" "autoscal" {
  desired_capacity     = 1
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ecslnchcfg.name
  max_size             = 2
  min_size             = 1
  name                 = "auto-scaling-group"

  tag {
    key                 = "Env"
    propagate_at_launch = true
    value               = "dev"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "blog"
  }

  target_group_arns    = [aws_alb_target_group.awstg.arn]
  termination_policies = ["OldestInstance"]

  vpc_zone_identifier = [
    aws_subnet.public_subneta.id,
    aws_subnet.public_subnetb.id
  ]
}
