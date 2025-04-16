variable "vpc_module_version" {
  description = "Version of the terraform-aws-modules/vpc/aws module"
  type        = string
  default     = "5.0.0"
}

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
  default     = {
    "kubernetes.io/role/elb" = "1"
  }
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default     = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

variable "tags" {
  description = "Global tags for resources"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "demo"
    CreatedBy   = "terraform-user"
  }
}
