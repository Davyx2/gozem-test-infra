# # # retrieve AMI 
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.server_ami]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  
}
