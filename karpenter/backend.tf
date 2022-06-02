terraform {
  backend "s3" {
    bucket         = "adriano-coutinho-bucket"
    key            = "kubernetes-labs/karpenter/terraform.tfstate"
    region         = "us-east-1"
  }
}
