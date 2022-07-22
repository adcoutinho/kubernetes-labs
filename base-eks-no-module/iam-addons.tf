################################################################################
# Cluster Autoscaler
################################################################################
resource "aws_iam_role" "clusterAutoscaler" {
  count = local.cluster_autoscaler_count

  name               = local.cluster_autoscaler_iam_role_name
  path               = "/"
  description        = "IAM Role for cluster autoscaler"
  assume_role_policy = data.aws_iam_policy_document.clusterAutoscalerAssumeRole.json
}

resource "aws_iam_policy" "clusterAutoscaler" {
  count = local.cluster_autoscaler_count

  name   = local.cluster_autoscaler_iam_policy_name
  policy = data.aws_iam_policy_document.clusterAutoscaler.json
}

resource "aws_iam_role_policy_attachment" "clusterAutoscaler" {
  count = local.cluster_autoscaler_count

  policy_arn = aws_iam_policy.clusterAutoscaler[0].arn
  role       = aws_iam_role.clusterAutoscaler[0].name
}

################################################################################
# External DNS
################################################################################
resource "aws_iam_role" "external_dns" {
  count = local.external_dns_count

  name               = local.external_dns_iam_role_name
  path               = "/"
  description        = "IAM role for external DNS"
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role.json
}

resource "aws_iam_policy" "external_dns" {
  count = local.external_dns_count

  name        = local.external_dns_iam_policy_name
  path        = "/"
  description = "Policy for external-dns to access Route53"
  policy      = data.aws_iam_policy_document.external_dns.json
}

resource "aws_iam_role_policy_attachment" "external_dns_attachment" {
  count = local.external_dns_count

  role       = aws_iam_policy.external_dns[0].name
  policy_arn = aws_iam_policy.external_dns[0].arn
}
