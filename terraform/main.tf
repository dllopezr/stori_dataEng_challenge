terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
  backend "s3" {
    bucket         = "dllr-tf-s3-backend"
    key            = "terraform.tfstate"
    region         = "us-east-2"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

# modules
module "storage" {
  source = "./modules/storage"
}

module "iam" {
  source = "./modules/iam"
}