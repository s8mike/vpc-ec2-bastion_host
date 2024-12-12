terraform {
  # Specify the required Terraform version
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # You can specify a version range or pin a version
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Specify the AWS region where you want to create resources
}



# Tags to apply on all resources
locals {
  tags = {
    owner          = "EK TECH SOFTWARE SOLUTION"
    environment    = "dev"
    project        = "del"
    create_by      = "Terraform"
    cloud_provider = "aws"
  }
}