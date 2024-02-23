module "alb_controller" {
  source = "./alb_controller"

  cluster_name            = local.cluster_name
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
  name_prefix             = var.name_prefix
  oidc_provider_arn       = var.oidc_provider_arn
  service_account_name    = var.service_account_name
}

module "sample_app" {
  depends_on = [module.alb_controller]
  source     = "./sample_app"
}
