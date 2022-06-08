terraform {
  backend "s3" {
    bucket         = "CHANGE-ME"
    key            = "kubernetes-labs/karpenter/terraform.tfstate"
    region         = "us-east-1"
  }
}
