output "helm_release_name" {
  description = "Helm release name for ALB Controller"
  value       = helm_release.aws_lb_controller.name
}
