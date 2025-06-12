terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
  # backend "s3" {
  #   bucket         = "serverless-project"
  #   key            = "terraform/state"
  #   region         = "us-west-2"
  #   dynamodb_table = "terraform-locks"
  # }
}

provider "aws" {
  region = var.aws_region

}