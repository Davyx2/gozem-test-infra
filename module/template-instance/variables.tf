#General variables
variable  "region" { 
  description = "region de Paris"
  default     = "eu-west-3"
  type        = string
}

#Volume EBS
variable "server_ami" {
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230907"
}

variable "tags" {
  default = "Test-Gozem"
}

#Instance
variable "ami_key_pair_project" {
  default = "project_key"
}
variable "pubkey-file" {
  default = "ssh/project.pub"
}
variable "size_ebs" {
  default = 30
  type = number
  description = "la taille de la partition principal"
}
variable "instance_type" {
  default = "t3.small"
}
variable "number_of_instances" {
  description = "number of instances to be created"
  default     = 1
}
variable "user-data-file" {
  default = "ec2-user-data.sh"
}

#Network

variable "subnet_id" {
  default = "subnet-06b1dbc8949682449"
}
variable "vpc_id" {
  default = "vpc-05957dfa1e0bf81f0"  
}

#Security groups
variable "security_group_project" {
  description = "List des ports autorise "
  default     = "security_project"
  type        = string
}

variable "security_group_id" {
  default = "sg-066f89bf9c39ef95b"
  description = "security groupes create"
  type = string
}








