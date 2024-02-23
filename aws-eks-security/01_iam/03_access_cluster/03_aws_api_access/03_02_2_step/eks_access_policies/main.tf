resource "aws_eks_access_entry" "this" {
  for_each = local.aws_eks_access_entries

  cluster_name = var.cluster_name
  kubernetes_groups = try(each.value.type == "STANDARD" &&
  length(regexall("system:.*", join(",", each.value.kubernetes_groups))) == 0 ? each.value.kubernetes_groups : null, null)
  principal_arn = each.value.principal_arn
  type          = try(each.value.type, "STANDARD")
  user_name     = try(each.value.type == "STANDARD" ? each.value.user_name : null, null)
}

resource "aws_eks_access_policy_association" "this" {
  depends_on = [
    aws_eks_access_entry.this
  ]
  for_each = local.aws_eks_access_policy_associations

  access_scope {
    namespaces = try(each.value.association_access_scope_namespaces, [])
    type       = each.value.association_access_scope_type
  }
  cluster_name  = var.cluster_name
  policy_arn    = each.value.association_policy_arn
  principal_arn = each.value.principal_arn
}
