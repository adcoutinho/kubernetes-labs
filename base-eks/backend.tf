terraform {
  backend "s3" {
    bucket         = "adriano-coutinho-bucket"
    key            = "kubernetes/base-eks/terraform.tfstate"
    region         = "us-east-1"
  }
}
