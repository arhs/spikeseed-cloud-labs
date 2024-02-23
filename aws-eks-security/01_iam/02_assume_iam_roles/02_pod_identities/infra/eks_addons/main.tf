resource "aws_eks_addon" "this" {
  for_each = { for k, v in var.cluster_addons : k => v }

  addon_name                  = try(each.value.addon_name, each.key)
  cluster_name                = var.cluster_name
  addon_version               = coalesce(try(each.value.addon_version, null), data.aws_eks_addon_version.this[each.key].version)
  configuration_values        = try(each.value.configuration_values, null)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts_on_create, "OVERWRITE")
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, "OVERWRITE")
  preserve                    = try(each.value.preserve, true)
  service_account_role_arn    = try(each.value.service_account_role_arn, null)
}
