data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "vpc-gozem"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "public"         = 1

  }

  private_subnet_tags = {
    "public"         = 0
  }
}

module "gozem-test" {
  source   = "./module/ecr"
  ecr-name = "gozem-test"
  tags-ecr = "api"
}

module "instance-module" {
  source = "./module/template-instance"

  #network
  security_group_project = "allow-https-ssh"
  subnet_id = "subnet-06b1dbc8949682449"
  vpc_id = "vpc-05957dfa1e0bf81f0"
  #instance
  ami_key_pair_project = "instance_module_key"
  tags                 = "Instance-module"
  pubkey-file          = "/home/seidou/Images/Test-gozem/design-vpc/ssh/project.pub"
  user-data-file       = "/home/seidou/Images/Test-gozem/design-vpc/ec2-user-data.sh"
}