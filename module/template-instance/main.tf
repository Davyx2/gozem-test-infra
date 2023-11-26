data "aws_vpc" "main" {
  id = var.vpc_id
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
    delete_on_termination = false
    volume_size = var.size_ebs
    }


  lifecycle {
    create_before_destroy = true
  }
}
