terraform {
  backend "s3" {
    encrypt = true
    bucket  = "terraform-state-4rytrtg46"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    profile = "kobing"
  }
}