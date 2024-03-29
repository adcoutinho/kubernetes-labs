locals {
  cluster_name      = "karpenter-test"
  cluster_version   = "1.22"

  region            = "us-east-1"

  # Used to determine correct partition (i.e. - `aws`, `aws-gov`, `aws-cn`, etc.)
  partition = data.aws_partition.current.partition

  tags = {
    Env            = "test"
    System         = "kubernetes"
    SubSystem      = "eks"
    Documentation  = "CHANGE-ME"
    Tribe          = "platform"
    CreationOrigin = "Terraform"
    Repository     = "CHANGE-ME"
    State          = "CHANGE-ME/kubernetes-labs/karpenter/terraform.tfstate"
  }
}
