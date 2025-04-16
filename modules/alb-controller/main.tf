# ALB Controller Module - Installs AWS Load Balancer Controller via Helm
resource "helm_release" "aws_lb_controller" {
  name       = var.helm_release_name
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.helm_chart_version
  create_namespace = false

  depends_on = [
    var.alb_controller_role_arn,
    var.eks_cluster_name
  ]

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }
  set {
    name  = "region"
    value = var.aws_region
  }
  set {
    name  = "vpcId"
    value = var.vpc_id
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.alb_controller_role_arn
  }
}
