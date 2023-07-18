resource "aws_security_group" "ingress-efs" {
   name = "ingress-efs-sg"
   vpc_id = "${aws_vpc.efs.id}"
   ingress {
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
   }
   egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
   }
 }
