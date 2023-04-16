provider "aws" {
    region = local.region
}

terraform {
  required_version = "~> 1.1.8"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.10"
    }
    cloudinit = {
        source = "hashicorp/cloudinit"
        version = "2.2.0"
    }
  }

  backend "s3" {
    bucket = "kubernetes-labs-terraform-state"
    key = "minikube/terraform.tfstate"
    region = "us-east-1"
  }
}
