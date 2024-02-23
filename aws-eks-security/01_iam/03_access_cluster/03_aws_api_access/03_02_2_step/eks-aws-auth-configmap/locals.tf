locals {
  aws_auth_configmap_data = {
    mapAccounts = yamlencode(var.aws_auth_accounts)
    mapRoles    = yamlencode(var.aws_auth_roles)
    mapUsers    = yamlencode(var.aws_auth_users)
  }
}
