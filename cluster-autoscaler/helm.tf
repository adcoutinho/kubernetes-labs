resource "helm_release" "cluster_autoscaler" { 
  name             = "cluster-autoscaler" 
  namespace        = "kube-system" 
  repository       = "https://kubernetes.github.io/autoscaler" 
  chart            = "cluster-autoscaler" 
  version          = "9.19.0" 
  create_namespace = false 
 
  set { 
    name  = "awsRegion" 
    value = local.region 
  } 
 
  set { 
    name  = "rbac.serviceAccount.name" 
    value = "cluster-autoscaler-aws" 
  } 
 
  set { 
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" 
    value = module.cluster_autoscaler_irsa.iam_role_arn 
    type  = "string" 
  } 
 
  set { 
    name  = "autoDiscovery.clusterName" 
    value = local.cluster_name 
  } 
 
  set { 
    name  = "autoDiscovery.enabled" 
    value = "true" 
  } 
 
  set { 
    name  = "rbac.create" 
    value = "true" 
  } 
 
  depends_on = [ 
    module.eks.cluster_id
  ] 
} 
