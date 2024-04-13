terraform {
  backend "s3" {
    region = "ca-central-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.45.0"
    }
  }

  required_version = ">= 1.6.2"
}

provider "aws" {
  region = "ca-central-1"
}
