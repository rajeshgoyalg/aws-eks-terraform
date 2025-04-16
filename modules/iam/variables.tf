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
  default     = "../../iam-policy.json"
}

variable "alb_controller_role_name" {
  description = "Name for the ALB Controller IAM role"
  type        = string
  default     = "AWSLoadBalancerControllerRole"
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL for IRSA"
  type        = string
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "demo"
    CreatedBy   = "terraform-user"
  }
}
