terraform {
  backend "s3" {
    bucket         = "CHANGE"
    key            = "kubernetes-labs/base-eks-no-module/terraform.tfstate"
    region         = "us-east-1"
  }
}
