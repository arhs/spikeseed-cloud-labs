output "iam_role_alb" {
  value = module.iam-roles.alb_iam_role_arn
}

output "iam_role_externaldns" {
  value = module.iam-roles.externaldns_role_arn
}

output "eks_cluster_name" {
  value = local.eks.cluster_name
}

output "argocd_cert_arn" {
  value = module.acm.argocd_cert_arn
}

output "application_cert_arn" {
  value = module.acm.application_cert_arn
}

output "waf_profile" {
  value = module.waf.aws_waf_arn
}