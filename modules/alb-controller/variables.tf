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

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the cluster"
  type        = string
}

variable "alb_controller_role_arn" {
  description = "ARN of the ALB Controller IAM role"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes service account name for the ALB Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}
