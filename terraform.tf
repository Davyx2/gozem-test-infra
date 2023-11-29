
terraform {
   backend "s3" {
    bucket  = "s3-network-cfg-state"
    region  = "eu-west-3"
    key     = "terraform.tfstate"
    profile = "admin-gozem-test"
  }
  required_providers { 
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    }
  }
}

