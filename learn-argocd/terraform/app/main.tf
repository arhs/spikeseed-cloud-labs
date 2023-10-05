module "argocd" {
  source               = "./argocd"
  argocd_chart_version = local.argocd.version
  argocd_ingress_host  = var.argocd_domain_name
  argocd_repos         = local.argocd.repos
  insecure             = true
  private_repos_config = var.private_repos_config #local.private_repos_config
  source_repo          = var.source_repo
}
