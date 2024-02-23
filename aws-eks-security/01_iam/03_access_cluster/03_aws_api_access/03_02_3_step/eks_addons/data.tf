data "aws_eks_addon_version" "this" {
  for_each = { for k, v in var.cluster_addons : k => v }

  addon_name         = try(each.value.name, each.key)
  kubernetes_version = coalesce(var.cluster_version, data.aws_eks_cluster.this[0].version)
  most_recent        = try(each.value.most_recent, null)
}

data "aws_eks_cluster" "this" {
  count = length(var.cluster_version) > 0 ? 0 : 1

  name = var.cluster_name
}
