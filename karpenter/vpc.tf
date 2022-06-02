module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = local.cluster_name
  cidr = "10.171.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.171.1.0/24", "10.171.2.0/24", "10.171.3.0/24"]
  public_subnets  = ["10.171.101.0/24", "10.171.102.0/24", "10.171.103.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = local.cluster_name
  }

  intra_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  tags = merge(local.tags, {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  })
}
