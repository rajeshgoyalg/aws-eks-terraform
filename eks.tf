module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "rg-eks-cluster"
  cluster_version = "1.31"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
  enable_irsa = true
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  
  cluster_addons = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = {}
    eks-pod-identity-agent = {}
  }

  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
    CreatedBy   = "terraform-user"
  }
}
