locals {
  cluster_name      = "cluster-autoscaler-test"
  cluster_version   = "1.22"

  region            = "us-east-1"

  # Used to determine correct partition (i.e. - `aws`, `aws-gov`, `aws-cn`, etc.)
  partition = data.aws_partition.current.partition

  tags = {
    Env            = "Lab"
    System         = "kubernetes"
    SubSystem      = "EKS"
    Documentation  = "CHANGE-ME"
    CreationOrigin = "Terraform"
    Repository     = "https://github.com/adcoutinho/kubernetes-labs"
    State          = "CHANGE-ME/kubernetes-labs/base-eks/terraform.tfstate"
  }
}
