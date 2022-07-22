################################################################################
# cluster role
################################################################################

resource "aws_iam_role" "cluster" {
  name               = coalesce(local.cluster_iam_role_name, var.cluster_iam_role_name) 
  path               = "/"
  description        = "IAM Role for EKS cluster"
  assume_role_policy = data.aws_iam_policy_document.cluster.json
}

resource "aws_iam_role_policy_attachment" "cluster" {
  for_each = toset(compact(distinct([
    "${var.policy_arn_prefix}/AmazonEKSClusterPolicy",
    "${var.policy_arn_prefix}/AmazonEKSVPCResourceController",
  ])))

  policy_arn = each.value
  role       = aws_iam_role.cluster.name
}

################################################################################
# cluster node role
################################################################################

resource "aws_iam_role" "node" {
  name               = coalesce(local.node_iam_role_name, var.node_iam_role_name)
  path               = "/"
  description        = "IAM Role for EKS node"
  assume_role_policy = data.aws_iam_policy_document.node.json
}

# Policies attached ref https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
resource "aws_iam_role_policy_attachment" "node" {
  for_each = toset(compact(distinct([
    "${var.policy_arn_prefix}/AmazonEKSWorkerNodePolicy",
    "${var.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly",
    "${var.policy_arn_prefix}/AmazonEKS_CNI_Policy",
  ])))

  policy_arn = each.value
  role       = aws_iam_role.node.name
}
