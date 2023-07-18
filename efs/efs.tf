resource "aws_efs_file_system" "efs-fs" {
   creation_token = "efs"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
 tags = {
     Name = "EfsExample"
   }
 }

resource "aws_efs_mount_target" "efs-mt" {
   file_system_id  = "${aws_efs_file_system.efs-fs.id}"
   subnet_id = "${aws_subnet.subnet-efs.id}"
   security_groups = ["${aws_security_group.ingress-efs.id}"]
 }
