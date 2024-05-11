terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
  backend "s3" {
    bucket         = "week10-terraform" #### Replace this by the name of your S3 bucket 
    key            = "050524/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "state-lock" ### Replace this by the name of your DynamoDB Table 
  }
}

provider "aws" {
  region = var.region
}
