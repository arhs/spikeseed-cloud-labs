import {
  for_each = local.import_aws_eks_access_entries
  id       = "${module.eks.eks_cluster_name}:${each.value.principal_arn}"
  to       = module.eks-access-policies[0].aws_eks_access_entry.this[each.value.principal_arn]
}

import {
  for_each = local.import_aws_eks_access_policy_associations
  id       = "${module.eks.eks_cluster_name}#${each.value.principal_arn}#${each.value.association_policy_arn}"
  to       = module.eks-access-policies[0].aws_eks_access_policy_association.this[each.value.principal_arn]
}
