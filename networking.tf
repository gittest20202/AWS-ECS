resource "aws_vpc" "ecsvpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Env  = "dev"
    Name = "vpc"
  }
}

resource "aws_subnet" "public_subneta" {
  availability_zone       = "us-east-1a"
  cidr_block              = "172.16.0.0/18"
  map_public_ip_on_launch = true

  tags = {
    Env  = "dev"
    Name = "public-us-east-1a"
  }

  vpc_id = aws_vpc.ecsvpc.id
}

resource "aws_subnet" "public_subnetb" {
  availability_zone       = "us-east-1b"
  cidr_block              = "172.16.64.0/18"
  map_public_ip_on_launch = true

  tags = {
    Env  = "dev"
    Name = "public-us-east-1b"
  }

  vpc_id = aws_vpc.ecsvpc.id
}

resource "aws_subnet" "private_subneta" {
  availability_zone       = "us-east-1a"
  cidr_block              = "172.16.128.0/18"
  map_public_ip_on_launch = false

  tags = {
    Env  = "dev"
    Name = "private-us-east-1a"
  }

  vpc_id= aws_vpc.ecsvpc.id
}

resource "aws_subnet" "private_subnetb" {
  availability_zone       = "us-east-1b"
  cidr_block              = "172.16.192.0/18"
  map_public_ip_on_launch = false

  tags = {
    Env  = "dev"
    Name = "private-us-east-1b"
  }

  vpc_id= aws_vpc.ecsvpc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecsvpc.id

  tags = {
    Env  = "dev"
    Name = "internet-gateway"
  }
}
resource "aws_route_table" "public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Env  = "dev"
    Name = "route-table-public"
  }

  vpc_id = aws_vpc.ecsvpc.id
}

resource "aws_route_table" "private" {
  tags = {
    Env  = "dev"
    Name = "route-table-private"
  }

  vpc_id = aws_vpc.ecsvpc.id
}


resource "aws_route_table_association" "public_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subneta.id
}

resource "aws_route_table_association" "public_b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnetb.id
}

resource "aws_route_table_association" "private_a" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_subneta.id
}

resource "aws_route_table_association" "private_b" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_subnetb.id
}


resource "aws_main_route_table_association" "routassociation" {
  route_table_id = aws_route_table.public.id
  vpc_id         = aws_vpc.ecsvpc.id
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

  vpc_id = aws_vpc.ecsvpc.id
}
