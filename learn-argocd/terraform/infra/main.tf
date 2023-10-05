# VPC and VPC-related resources module
module "vpc" {
  source = "./vpc"

  azs             = local.vpc.azs
  name            = local.vpc.name
  private_subnets = local.vpc.private_subnets
  public_subnets  = local.vpc.public_subnets
  vpc_cidr        = local.vpc.vpc_cidr
}
# EKS module
module "eks" {
  source = "./eks"

  cluster_name                         = local.eks.cluster_name
  cluster_version                      = local.eks.cluster_version
  eks_cluster_role_name                = local.eks.eks_cluster_role_name
  kms_policy                           = data.aws_iam_policy_document.eks_key.json
  name_prefix                          = local.name_prefix
  ssm_prefix                           = local.ssm_prefix
  subnet_ids                           = module.vpc.private_subnets_ids
  vpc_id                               = module.vpc.vpc_id
  workers_sg_allowed_cidrs             = [module.vpc.vpc_cidr]
  cluster_endpoint_public_access_cidrs = local.eks.cluster_endpoint_public_access_cidrs
}
# Update the aws-auth config map module
module "eks-aws-auth-configmap" {
  depends_on = [module.eks]
  source = "./eks-aws-auth-configmap"

  admin_users_role_arn = module.eks.eks_admin_users_role
  cluster_name         = local.eks.cluster_name
  worker_node_role_arn = module.eks.eks_worker_node_role
}
# Create node groups module
module "eks-ng" {
  depends_on = [module.eks]
  source     = "./eks-ng"

  cluster_name                       = local.eks.cluster_name
  cluster_version                    = local.eks.cluster_version
  ng_ami_type                        = local.nodes.node_group.ng_ami_type
  ng_desired_capacity                = local.nodes.node_group.ng_desired_capacity
  ng_max_capacity                    = local.nodes.node_group.ng_max_capacity
  ng_min_capacity                    = local.nodes.node_group.ng_min_capacity
  node_group_name                    = local.nodes.node_group.node_group_name
  subnets                            = module.vpc.private_subnets_ids
  workers_instance_type              = local.nodes.workers_instance_type
  workers_max_unavailable_percentage = local.nodes.node_group.workers_max_unavailable_percentage
  workers_role_arn                   = module.eks.eks_worker_node_role
  workers_security_group_id          = module.eks.eks_worker_node_security_group_id
}
# Create IAM roles module
module "iam-roles" {
  depends_on = [module.eks]
  source     = "./iam"

  alb_controller_role_name            = "${local.name_prefix}-alb-controller"
  alb_controller_service_account_name = "${local.name_prefix}-alb-controller"
  cluster_name                        = local.eks.cluster_name
  cluster_oidc_issuer_url             = module.eks.cluster_oidc_issuer_url
  external_dns_controller_role_name   = "${local.name_prefix}-external-dns"
  external_dns_service_account_name   = "${local.name_prefix}-external-dns"
  oidc_provider_arn                   = module.eks.oidc_provider_arn
}
# Create a WAF profile module
module "waf" {
  source = "./waf"

  name_prefix = local.name_prefix
}
# Create application certificates module
module "acm" {
  source = "./acm"

  application_domain_name = local.dns.application_domain_name
  argocd_domain_name      = local.dns.argocd_domain_name
  zone_id                 = var.dns_zone_id
}

