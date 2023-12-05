
data "aws_vpc" "main" {
  id = var.vpc_id
}

data "http" "public_ip_ec2" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_key_pair" "main" {
  public_key = file(var.pubkey-file)
  key_name   = var.ami_key_pair_project
}

resource "aws_launch_template" "main" {
  name = var.launchtemplate-name
  
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_size = var.size_ebs
    }
  }
   instance_type = var.instance_type

   ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.profile.name
  }

  image_id = "ami-0c03e02984f6a0b41" #data.aws_ami.ubuntu.id

  instance_initiated_shutdown_behavior = "terminate"

  key_name = aws_key_pair.main.key_name

  monitoring {
    enabled = true
  }

  network_interfaces {
    security_groups = [ aws_security_group.sg-ec2.id ]
    associate_public_ip_address = true
  }
   

  user_data = filebase64(var.user-data-file)

    lifecycle {
    create_before_destroy = true
  }
}
