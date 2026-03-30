terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.15.0"
    }
  }

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "akash6975"

    workspaces {
      name = "cfl-workspace"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}
