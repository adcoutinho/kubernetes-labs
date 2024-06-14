module "eks" {
  for_each = local.cluster_config.cluster
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = each.value.name
  cluster_version = each.value.version

  cluster_endpoint_public_access  = true
  authentication_mode = "API_AND_CONFIG_MAP"

  cluster_addons = local.addons

  vpc_id                   = local.vpc_id
  subnet_ids               = local.subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    example = {
      min_size     = 1
      max_size     = 10
      desired_size = each.value.desired_size

      instance_types = [each.value.instance_types]
      capacity_type  = "SPOT"
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = local.access_entries

  tags = local.tags
}
