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

resource "aws_launch_configuration" "main" {
  name_prefix = "app-"

  image_id =  data.aws_ami.ubuntu.id  #"ami-087c17d1fe0178315" 
  instance_type = var.instance_type
  key_name = aws_key_pair.main.key_name

  iam_instance_profile   = aws_iam_instance_profile.profile.name
  
  security_groups = [ aws_security_group.sg-ec2.id ]
  associate_public_ip_address = true
 
  #user_data = file(var.user-data-file)

  root_block_device {
    delete_on_termination = true
    volume_size = var.size_ebs
    }

  #  provisioner "file" {
  #    source = file(var.user-data-file)
  #    destination = "/tmp/script.sh"
  #  }

  #  connection {
  #   type     = "ssh"
  #   user     = "ubuntu"
  #   private_key = file(var.privkey-file)
  #   host     = var.public_ip
  #   timeout = "4m"
  #  }

  #   provisioner "remote-exec" {
  #     inline=[
  #     "sudo chmod +x /tmp/script.sh",
  #     "sudo /tmp/script.sh"
  #     ]
  #   }

  lifecycle {
    create_before_destroy = true
  }
}

