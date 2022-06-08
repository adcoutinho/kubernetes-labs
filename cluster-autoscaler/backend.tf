terraform {
  backend "s3" {
    bucket         = "CHANGE-ME"
    key            = "kubernetes-labs/cluster-autoscaler/terraform.tfstate"
    region         = "us-east-1"
  }
}
