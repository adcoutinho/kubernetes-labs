locals {
  cluster_config = yamldecode(file("clusters.yaml")) 

  vpc_id = "vpc-1234556abcdef"
  subnet_ids = ["subnet-0375259499a99f72e", "subnet-057f488525a12a33b", "subnet-09266394c60db87fd"]

  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  access_entries = {}

  tags = {
    Environment = "lab"
    Terraform   = "true"
  }
}
