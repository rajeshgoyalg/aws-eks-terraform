variable "eks_module_version" {
  description = "Version of the terraform-aws-modules/eks/aws module"
  type        = string
  default     = "~> 20.0"
}

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

variable "vpc_id" {
  description = "VPC ID for EKS"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS nodes"
  type        = list(string)
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
  default     = {
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

variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "demo"
    CreatedBy   = "terraform-user"
  }
}
