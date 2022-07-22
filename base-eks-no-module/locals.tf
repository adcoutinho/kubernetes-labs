locals {

  # AWS Account Settings

  # Used to determine correct partition (i.e. - `aws`, `aws-gov`, `aws-cn`, etc.)
  partition = data.aws_partition.current.partition

  # Cluster Settings  
  cluster_name = "cluster-eks-${terraform.workspace}"
  cluster_version = "1.22.10"
  # EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)
  cluster_log_types = ["audit", "api", "authenticator"]
  cluster_security_group_ids = []
  control_plane_subnet_ids = []
  node_groups_subnet_ids = []
  # Cluster admin access from where
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access = true
  # Default 10.100.0.0/16 or 172.20.0.0/16
  cluster_service_ipv4_cidr = ""
  create_cluster_primary_security_group_tags = true
  cluster_addons = {}
  cluster_identity_providers = {}
  # Fargate
  fargate_profiles = {}
  fargate_profile_defaults = {}
  # Self Managed Node Group
  self_managed_node_groups = {}
  self_managed_node_group_defaults = {}
  # EKS Managed Node Group
  eks_managed_node_groups = {}
  eks_managed_node_group_defaults = {}

  # Node Group
  capacity_type = ""

  # IAM Settings (Here or default in variables like cluster and node iam role names)


  tags = {
    Env            = "Lab"
    System         = "kubernetes"
    SubSystem      = "EKS"
    Documentation  = "CHANGE-ME"
    CreationOrigin = "Terraform"
    Repository     = "https://github.com/adcoutinho/kubernetes-labs"
    State          = "CHANGE-ME/kubernetes-labs/base-eks-no-module/terraform.tfstate"
  }
}
