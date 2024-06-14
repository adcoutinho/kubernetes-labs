terraform {
  backend "s3" {
    bucket         = "kubernetes-labs-terraform-state"
    key            = "eks-terraform-module/terraform.tfstate"
    region         = "us-east-1"
  }
}
