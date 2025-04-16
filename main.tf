terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  vpc_azs             = var.vpc_azs
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
  tags                = var.tags
}

module "eks" {
  source                               = "./modules/eks"
  cluster_name                         = var.cluster_name
  cluster_version                      = var.cluster_version
  vpc_id                               = module.vpc.vpc_id
  subnet_ids                           = module.vpc.private_subnets
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_addons                       = var.cluster_addons
  node_instance_types                  = var.node_instance_types
  eks_managed_node_groups              = var.eks_managed_node_groups
  tags                                 = var.tags
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

module "iam" {
  source                     = "./modules/iam"
  eks_cluster_role_name      = var.eks_cluster_role_name
  alb_controller_policy_name = var.alb_controller_policy_name
  alb_controller_policy_json = var.alb_controller_policy_json
  alb_controller_role_name   = var.alb_controller_role_name
  oidc_provider_arn         = data.aws_iam_openid_connect_provider.this.arn
  oidc_provider_url         = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  tags                      = var.tags
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

module "alb_controller" {
  source                  = "./modules/alb-controller"
  helm_release_name       = var.helm_release_name
  helm_chart_version      = var.helm_chart_version
  eks_cluster_name        = module.eks.cluster_name
  aws_region              = var.aws_region
  vpc_id                  = module.vpc.vpc_id
  alb_controller_role_arn = module.iam.alb_controller_role_arn
  service_account_name    = var.service_account_name
}
