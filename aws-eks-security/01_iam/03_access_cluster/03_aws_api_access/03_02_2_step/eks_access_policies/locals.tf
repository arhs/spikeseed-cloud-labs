locals {
  aws_eks_access_entries = { for key, value in var.cluster_access_config_api : value.principal_arn => value }
  aws_eks_access_policy_associations = { for key, value in var.cluster_access_config_api : value.principal_arn => value
  if value.type == "STANDARD" && value.kubernetes_groups != "" && value.association_policy_arn != "" }
}
