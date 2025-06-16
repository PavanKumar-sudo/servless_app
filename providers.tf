terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
  backend "s3" {
    bucket         = "project-servless"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region

}