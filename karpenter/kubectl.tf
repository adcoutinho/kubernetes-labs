resource "kubectl_manifest" "karpenter_provisioner_spot" {
  yaml_body = <<-YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: default
  spec:
    requirements:
      - key: karpenter.sh/capacity-type
        operator: In
        values: ["spot"]
      - key: "kubernetes.io/arch"
        operator: In
        values: ["amd64"]
      - key: "topology.kubernetes.io/zone" 
        operator: In
        values: ["us-east-1a", "us-east-1b", "us-east-1c"]
    limits:
      resources:
        cpu: 1000
    provider:
      subnetSelector:
        karpenter.sh/discovery: ${local.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${local.cluster_name}
      tags:
        karpenter.sh/discovery: ${local.cluster_name}
    ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_example_deployment" {
  yaml_body = <<-YAML
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: inflate
  spec:
    replicas: 0
    selector:
      matchLabels:
        app: inflate
    template:
      metadata:
        labels:
          app: inflate
      spec:
        terminationGracePeriodSeconds: 0
        containers:
          - name: inflate
            image: public.ecr.aws/eks-distro/kubernetes/pause:3.2
            resources:
              requests:
                cpu: 1
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}
