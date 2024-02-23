module "alb_controller" {
  source = "./alb_controller"

  cluster_name         = local.cluster_name
  name_prefix          = local.name_prefix
  service_account_name = var.service_account_name
}

resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = local.cluster_name
  namespace       = var.namespace
  service_account = var.service_account_name
  role_arn        = module.alb_controller.iam_role_arn
}

module "sample_app" {
  depends_on = [module.alb_controller]
  source     = "./sample_app"
}
