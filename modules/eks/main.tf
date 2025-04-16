# EKS Module - Uses terraform-aws-modules/eks/aws
module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  enable_irsa                   = true
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  cluster_addons = var.cluster_addons

  eks_managed_node_group_defaults = {
    instance_types = var.node_instance_types
  }

  eks_managed_node_groups = var.eks_managed_node_groups

  tags = var.tags
}
