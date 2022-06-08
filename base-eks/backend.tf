terraform {
  backend "s3" {
    bucket         = "CHANGE"
    key            = "kubernetes/base-eks/terraform.tfstate"
    region         = "us-east-1"
  }
}
