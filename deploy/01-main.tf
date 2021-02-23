provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "react-serverless-app-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}