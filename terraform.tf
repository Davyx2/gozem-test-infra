
terraform {
   backend "s3" {
    bucket  = "s3-network-cfg-state"
    region  = "eu-west-3"
    key     = "terraform.tfstate"
    profile = "admin-gozem-test"
  }
}