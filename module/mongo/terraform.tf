provider "mongodbatlas" {
  private_key = var.private_key
  public_key = var.public_key
}
terraform {
  required_providers { 
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.13.1"
  }
}
}