locals {
  cluster_name      = "cluster-autoscaler-test"
  cluster_version   = "1.22"

  region            = "us-east-1"

  # Node Group parameters
  instance_types    = ["m5.large", "m5.2xlarge", "m5.4xlarge", "t3.medium", "m4.large", "m4.2xlarge"]
  desired_size      = 3
  max_size          = 20
  min_size          = 3
  disk_size         = 10
  capacity_type     = "SPOT"


  tags = {
    Env            = "test"
    System         = "kubernetes"
    SubSystem      = "eks"
    Documentation  = "CHANGE-ME"
    Tribe          = "platform"
    CreationOrigin = "Terraform"
    Repository     = "CHANGE-ME"
    State          = "CHANGE-ME/kubernetes-labs/cluster-autoscaler/terraform.tfstate"
  }
}
