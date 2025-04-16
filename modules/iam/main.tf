# IAM Module - Creates IAM roles and policies for EKS and ALB Controller

resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# ALB Controller IAM Policy
resource "aws_iam_policy" "alb_controller_policy" {
  name        = var.alb_controller_policy_name
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file(var.alb_controller_policy_json)
}

resource "aws_iam_role" "alb_controller_role" {
  name = var.alb_controller_role_name
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role_policy.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Construct the OIDC provider URL for the trust policy (removes https:// prefix)
locals {
  oidc_url_no_scheme = replace(var.oidc_provider_url, "https://", "")
}

data "aws_iam_policy_document" "alb_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url_no_scheme}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

