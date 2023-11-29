variable "username" {
  description = "The Username for the MongoDB Atlas Login"
  sensitive = false
}

variable "org_id" {
  description = "The organisation id of the mongodb Login"
  sensitive = true
}

variable "project-name" {
  default = "database-app-gozem"
}

variable "provider_name" {
  default = "AWS"
  type = string
}

variable "atlas_cidr_block" {
  default = "10.0.0.0/16"
  type = string
}

variable "mongodb_region" {
  default = "EU_WEST_3"
}

variable "cluster_name" {
  default = "app-gozem-cluster"
}

variable "db_username" {
  default = "admin"
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "db_name" {
  default = "db_api_gozem"
}

variable "private_key" {
  type = string
  default = "eeeeeeeeee"
  sensitive = true
}

variable "public_key" {
  type = string
  default = "zzzzzzzzzzz"
  sensitive = true
}

variable "aws_account_id" {
  default = "xxxxxxxxxxxxxxxxx"
  sensitive = true
}

variable "vpc_id_db" {
  default = "zzzzzz"
}

variable "route_table_cidr_block_aws" {
  default = "zzzzzzzzz"
}

variable "vpc_id_aws" {
  default = "zzzzzzzzzzz"
}


variable "accepter_region_name" {
  default = "eu-west-3"
}

variable "aws_route_table_id" {
  default = "eeeeeee"
}

variable "aws_vpc_cidr_block" {
  default = "zzzzzzzzzzzzzzz"
}

#username=manassehsuccess0@gmail.com
#pub=cdgffndc
#priva=85c89d47-4335-43c0-953c-8dd7697357fa
#org=655f8cd0960462359737ae6e
