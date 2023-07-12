data "aws_vpc" "ecs" {
   filter {
     name = "tag:Name"
     values = ["vpc"]
   }
 }

data "aws_subnet" "publica" {
    filter {
       name = "tag:Name"
       values = ["public_subneta"]
}
}

data "aws_subnet" "publicb" {
    filter {
       name = "tag:Name"
       values = ["public_subnetb"]
}
}

data "aws_subnet" "privatea" {
    filter {
       name = "tag:Name"
       values = ["private_subneta"]
}
}

data "aws_subnet" "privateb" {
    filter {
       name = "tag:Name"
       values = ["private_subnetb"]
}
}

resource "aws_security_group" "ec2" {
  description = "security-group-ec2"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 0
    protocol        = "tcp"
    security_groups = [aws_security_group.sgalb.id]
    to_port         = 65535
  }

  name = "security-group-ec2"

  tags = {
    Env  = "dev"
    Name = "security-group-ec2"
  }

  vpc_id = data.aws_vpc.ecs.id
}
