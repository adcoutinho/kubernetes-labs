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
}
