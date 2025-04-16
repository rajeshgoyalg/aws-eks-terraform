# Root-level variables for multi-module EKS deployment

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "terraform-user"
}

# VPC variables
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "demo-app-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT Gateway"
  type        = bool
  default     = true
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default = {
    "kubernetes.io/role/elb" = "1"
  }
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# EKS variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "demo-app-eks-cluster"
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS endpoint is publicly accessible"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDRs allowed to access the EKS endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_addons" {
  description = "Map of EKS cluster addons"
  type        = map(any)
  default = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = {}
    eks-pod-identity-agent = {}
  }
}

variable "node_instance_types" {
  description = "List of instance types for node groups"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node groups"
  type        = any
  default = {
    demo-app = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }
}

# IAM & ALB Controller variables
variable "eks_cluster_role_name" {
  description = "Name for the EKS cluster IAM role"
  type        = string
  default     = "demo-app-eks-cluster-role"
}

variable "alb_controller_policy_name" {
  description = "Name for the ALB Controller IAM policy"
  type        = string
  default     = "AWSLoadBalancerControllerIAMPolicy"
}

variable "alb_controller_policy_json" {
  description = "Path to the ALB Controller IAM policy JSON file"
  type        = string
  default     = "./iam-policy.json"
}

variable "alb_controller_role_name" {
  description = "Name for the ALB Controller IAM role"
  type        = string
  default     = "AWSLoadBalancerControllerRole"
}


# ALB Controller Helm variables
variable "helm_release_name" {
  description = "Helm release name for the ALB Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "helm_chart_version" {
  description = "Helm chart version for the ALB Controller"
  type        = string
  default     = "1.7.1"
}

variable "service_account_name" {
  description = "Kubernetes service account name for the ALB Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

# Global tags
variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "demo"
    CreatedBy   = "terraform-user"
  }
}
