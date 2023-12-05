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
  vpc_id = module.vpc.vpc_id
  public-subnet-for-instance = module.vpc.public_subnets
  #instance
  ami_key_pair_project = "instance_module_key"
  tags                 = "Instance-module"
  user-data-file       = "/home/seidou/Images/Test-gozem/design-vpc/ec2-user-data.sh"
  pubkey-file          = "/home/seidou/Images/Test-gozem/design-vpc/ssh/project.pub"
  
  #sns
  email = "manassehsuccess0@gmail.com"
  protocol = "email"
  instance-topic-name = "topic-server"
}

module "mongodb-atlas-peering" {
  source = "./module/mongo"
  private_key = var.private_key
  public_key = var.public_key
  username = "manassehsuccess0@gmail.com"
  org_id = var.org_id
  db_username = "david"
   db_password = var.db_password
   db_name = "db-api-gozem"
  accepter_region_name = "eu-west-3"
  aws_account_id = var.aws_account_id
  route_table_cidr_block_aws =  module.vpc.vpc_cidr_block
  aws_route_table_id = module.vpc.default_route_table_id 
  vpc_id_aws = module.vpc.vpc_id
  aws_vpc_cidr_block = module.vpc.vpc_cidr_block
}
