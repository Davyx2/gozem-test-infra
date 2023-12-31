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
variable "privkey-file" {
  default = "ssh/project"
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
variable "public-subnet-for-instance" {
  description = "Sous reseaux public" 
  type        = list(string) 
  default = [ 
    "",
    ""
   ]
}
variable "subnet_id" {
  default = "" 
}
variable "vpc_id" {
  default = ""  
}

#Security groups
variable "security_group_project" {
  description = "List des ports autorise "
  default     = "security_project"
  type        = string
}

variable "security_group_id" {
  default = ""
  description = "security groupes create"
  type = string
}

#elb
variable "elb-name" {
  default = "elb-gozem-test"
}
variable "elb-incomming-port" {
  default = 80
}

variable "health_check_type" {
  default = "ELB"
}
#asg
variable "asg-policy" {
  default = "asg_policy_up"
  type = string
}

variable "tg-name" {
  default = "tg-gozem-test"
}

variable "tg-port" {
  default = 8080
}

variable "scaling_adjustment" {
  default = 1
  type = number
}
variable "adjustment_type" {
  default = "ChangeInCapacity"
}

variable "cooldown" {
  default = 300
  type = number
}
variable "min_size" {
  default = 2
  type = number
}
variable "max_size" {
  default = 3
  type = number
}
variable "desired_capacity" {
  default = 2
  type = number
}
variable "metrics_granularity" {
  default = "1Minute"
}

#sns
variable "protocol" {
  default = "email"
}

variable "email" {
  default = "seidoudavid97@gmail.com"
}

variable "instance-topic-name" {
  default = "instance-topic"
}

variable "topic-app" {
  default = "topic-application"
}

variable "target-port-api" {
  default = 8080
}

variable "public_ip" {
  default = "éééééééé"
}
variable "launchtemplate-name" {
  default = "server-template"
}