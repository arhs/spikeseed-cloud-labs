output "alb_iam_role_arn" {
  value = aws_iam_role.aws_loadbalancer_controller.arn
}

output "externaldns_role_arn" {
  value = aws_iam_role.external_dns_controller.arn
}