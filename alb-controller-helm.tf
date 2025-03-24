resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.1"
  create_namespace = false

  depends_on = [
    aws_iam_role.aws_lb_controller_irsa,
    module.eks
  ]

  set { # clusterName
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set { # region
    name  = "region"
    value = "ap-southeast-1"
  }

  set { # vpcId
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_lb_controller_irsa.arn
  }
}