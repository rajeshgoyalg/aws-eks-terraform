# AWS EKS Modular Terraform Infrastructure

## Project Overview

This project provisions a complete, production-ready AWS Elastic Kubernetes Service (EKS) environment using a modular Terraform architecture. It includes:
- **VPC** networking
- **EKS** cluster with managed node groups
- **IAM** roles and policies (with IRSA for ALB Controller)
- **AWS Load Balancer Controller** (ALB Controller) via Helm
- All necessary dependencies for deploying containerized workloads on AWS

This setup is ideal for DevOps teams seeking a repeatable, scalable, and secure Kubernetes platform on AWS.

---

## Architecture

```
VPC (modules/vpc)
  └─ Subnets (public/private)
      └─ EKS Cluster (modules/eks)
            └─ Managed Node Groups
            └─ OIDC Provider for IRSA
      └─ IAM (modules/iam)
            └─ EKS Cluster Role
            └─ ALB Controller Role & Policy
      └─ ALB Controller (modules/alb-controller)
            └─ Deployed via Helm, using IRSA
```

- **VPC**: Provides isolated networking for the cluster.
- **EKS**: Manages the Kubernetes control plane and worker nodes.
- **IAM**: Handles identity, access, and IRSA for secure service account roles.
- **ALB Controller**: Enables Kubernetes Ingress using AWS ALB.

---

## Prerequisites

- [Terraform >= 1.3.0](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm >= 2.8](https://helm.sh/docs/intro/install/)
- AWS account with sufficient IAM permissions

---

## Folder Structure

```
terraformization/
├── backend.tf
├── iam-policy.json
├── ingress.json
├── main.tf
├── modules/
│   ├── alb-controller/
│   ├── eks/
│   ├── iam/
│   └── vpc/
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── variables.tf
└── README.md
```

---

## Setup Instructions

### 1. Clone the Repository
```sh
git clone <your-repo-url>
cd terraformization
```

### 2. Configure Backend (Optional)
Edit `backend.tf` to update S3 bucket, DynamoDB table, and region for state storage.

### 3. Initialize Terraform
```sh
terraform init
```

### 4. Configure Variables
Edit `terraform.tfvars` or override variables via CLI. See [Configurable Variables](#configurable-variables) for details.

### 5. Plan and Apply
```sh
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### 6. (Optional) Access the Cluster
After apply, configure your kubeconfig:
```sh
aws eks update-kubeconfig --region <aws_region> --name <cluster_name>
```

### 7. (Optional) Verify ALB Controller
Check that the AWS Load Balancer Controller is running in the `kube-system` namespace:
```sh
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```

---

## Module Descriptions

### modules/vpc
- Provisions a VPC, public/private subnets, NAT gateways, and subnet tags for Kubernetes.
- Uses `terraform-aws-modules/vpc/aws`.

### modules/eks
- Deploys an EKS cluster and managed node groups.
- Enables IRSA and cluster addons (CoreDNS, kube-proxy, VPC CNI, etc).
- Uses `terraform-aws-modules/eks/aws`.

### modules/iam
- Creates IAM roles for EKS cluster and ALB Controller.
- Attaches required AWS managed and custom policies.
- Sets up IRSA trust for the ALB Controller.

### modules/alb-controller
- Installs AWS Load Balancer Controller via Helm.
- Configures IRSA with the appropriate IAM role.

---

## Configurable Variables

Key variables from `variables.tf` (root):

| Name                          | Description                                       | Default                        |
|-------------------------------|---------------------------------------------------|--------------------------------|
| aws_region                    | AWS region to deploy resources                    | ap-southeast-1                 |
| aws_profile                   | AWS CLI profile                                   | terraform-user                 |
| vpc_name                      | Name of the VPC                                   | demo-app-vpc                   |
| vpc_cidr                      | CIDR block for the VPC                            | 10.0.0.0/16                    |
| vpc_azs                       | List of AZs                                       | [ap-southeast-1a, ...]         |
| private_subnets               | Private subnet CIDRs                              | [10.0.1.0/24, ...]             |
| public_subnets                | Public subnet CIDRs                               | [10.0.101.0/24, ...]           |
| enable_nat_gateway            | Enable NAT Gateway                                | true                           |
| single_nat_gateway            | Use single NAT Gateway                            | true                           |
| cluster_name                  | Name of the EKS cluster                           | demo-app-eks-cluster           |
| cluster_version               | EKS Kubernetes version                            | 1.31                           |
| cluster_endpoint_public_access | Public EKS API access                             | true                           |
| cluster_endpoint_public_access_cidrs | Allowed CIDRs for EKS API                | [0.0.0.0/0]                    |
| node_instance_types           | EC2 instance types for nodes                      | [t3.medium]                    |
| eks_managed_node_groups       | Node group config                                 | see variables.tf               |
| eks_cluster_role_name         | Name for EKS cluster IAM role                     | demo-app-eks-cluster-role      |
| alb_controller_policy_name    | Name for ALB Controller IAM policy                | AWSLoadBalancerControllerIAMPolicy |
| alb_controller_policy_json    | Path to ALB Controller IAM policy JSON            | ./iam-policy.json              |
| alb_controller_role_name      | Name for ALB Controller IAM role                  | AWSLoadBalancerControllerRole  |
| helm_release_name             | Helm release name for ALB Controller              | aws-load-balancer-controller   |
| helm_chart_version            | Helm chart version for ALB Controller             | 1.7.1                          |
| service_account_name          | K8s service account for ALB Controller            | aws-load-balancer-controller   |
| tags                          | Global resource tags                              | see variables.tf               |

For a complete list, see [`variables.tf`](variables.tf) and module variable files.

---

## Outputs

Key outputs from the root and modules:

- **vpc_id**: VPC ID
- **private_subnets**: List of private subnet IDs
- **public_subnets**: List of public subnet IDs (module)
- **eks.cluster_name**: EKS cluster name
- **eks.cluster_endpoint**: EKS API endpoint
- **eks.cluster_certificate_authority_data**: Base64 CA data
- **eks.oidc_provider_arn**: OIDC provider ARN for IRSA
- **iam.eks_cluster_role_arn**: ARN of EKS cluster IAM role
- **iam.alb_controller_role_arn**: ARN of ALB Controller IAM role
- **alb-controller.helm_release_name**: Helm release name for ALB Controller

---

## Security & Best Practices

- **IAM Roles**: Uses least-privilege roles for EKS and ALB Controller. IRSA (IAM Roles for Service Accounts) is enabled for secure pod-level permissions.
- **Tagging**: All resources are tagged for traceability and cost management.
- **State Management**: Remote S3 backend with DynamoDB locking is recommended (see `backend.tf`).
- **Subnet Tagging**: Subnets are tagged for Kubernetes load balancer discovery.

---

## Usage Example

```sh
# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan -var-file=terraform.tfvars

# Apply
terraform apply -var-file=terraform.tfvars

# Update kubeconfig for kubectl
aws eks update-kubeconfig --region ap-southeast-1 --name demo-app-eks-cluster
```

## Deploy Your Microservices
Clone the manifests repo:
`git clone https://github.com/rajeshgoyalg/demo-kubernetes-configs`
`cd demo-kubernetes-configs`

## Apply resources:
```
kubectl apply -f demo-flask-app/deployment.yaml
kubectl apply -f demo-flask-app/service.yaml
kubectl apply -f demo-flask-app/ingress.yaml
```
## ✅ Verify and Test

Check resources:
```
kubectl get deployments
kubectl get pods
kubectl get services
kubectl get ingress
```
The output will display the ADDRESS field, which contains the ALB URL.

Test your service:
`curl http://<ALB-URL>/`

---

## Troubleshooting

- **ALB Not Created**: Ensure subnets are tagged with `kubernetes.io/role/elb` or `kubernetes.io/role/internal-elb`.
- **IAM Role Issues**: Confirm IRSA is set up and the ALB Controller IAM role is annotated on the service account.
- **kubectl/Helm Failures**: Verify kubeconfig, AWS credentials, and Helm version.
- **State Locking Errors**: Check S3 bucket and DynamoDB table for backend state.

---

## License

MIT License. See [LICENSE](../LICENSE) for details.

## Contributions

Contributions are welcome! Please open issues or submit PRs for improvements.