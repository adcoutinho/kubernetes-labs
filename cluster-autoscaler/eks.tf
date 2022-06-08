module "eks" {
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
  source  = "terraform-aws-modules/eks/aws"
  version = "18.21.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  create_cloudwatch_log_group = false

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      version           = "1.11.0-eksbuild.1"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  node_security_group_additional_rules = {
    # Extend node-to-node security group rules
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "fargate"
          labels = {
            WorkerType = "fargate"
          }
        }
      ]

      subnet_ids = module.vpc.private_subnets

      tags = {
        Owner = "default"
      }

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }

  eks_managed_node_groups = {
    eks-node = {
      instance_types = local.instance_types

      min_size     = local.min_size
      max_size     = local.max_size
      desired_size = local.desired_size

      disk_size      = local.disk_size
      capacity_type  = local.capacity_type

    }

    tags = merge(local.tags, {
      "k8s.io/cluster-autoscaler/enabled" = true,
      "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned",
    })
  }

  tags = local.tags
  
}
