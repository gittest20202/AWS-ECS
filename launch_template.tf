resource "aws_launch_template" "ecslnctmpt" {
  name       = "ecs-template"
  iam_instance_profile {
       name = aws_iam_instance_profile.ecs.name
  }
  image_id                    = data.aws_ami.ecsami.id
  instance_type               = "t3.micro"
  key_name                    = "blog"

  lifecycle {
    create_before_destroy = true
  }


  block_device_mappings {
     device_name = "/dev/sda1"
     ebs {
       volume_size = 20
       volume_type = "gp2"
  }
}
  network_interfaces {
     associate_public_ip_address = true
     security_groups = [aws_security_group.ec2.id]
  }
  user_data       = filebase64("user_data.sh")
}
