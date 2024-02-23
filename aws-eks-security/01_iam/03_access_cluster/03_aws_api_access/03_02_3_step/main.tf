module "vpc" {
  source = "./vpc"

  azs             = local.vpc.azs
  name            = local.vpc.name
  private_subnets = local.vpc.private_subnets
  public_subnets  = local.vpc.public_subnets
  vpc_cidr        = local.vpc.vpc_cidr
}

module "eks" {
  source = "./eks"

  access_configuration                 = local.eks.access.access_config
  cluster_endpoint_public_access_cidrs = local.eks.access.cluster_endpoint_public_access_cidrs
  cluster_name                         = local.eks.cluster_name
  cluster_version                      = local.eks.cluster_version
  configure_access                     = local.eks.access.configure_access
  create_oidc_provider                 = true
  eks_cluster_role_name                = local.eks.eks_cluster_role_name
  name_prefix                          = local.name_prefix
  subnet_ids                           = module.vpc.private_subnets_ids
  vpc_id                               = module.vpc.vpc_id
  workers_sg_allowed_cidrs             = [module.vpc.vpc_cidr]
}

module "eks-ng" {
  depends_on = [module.eks, module.aws-auth]
  source     = "./eks-ng"

  cluster_name                       = module.eks.eks_cluster_name
  cluster_version                    = module.eks.eks_cluster_version
  ng_ami_type                        = local.nodes.node_group.ng_ami_type
  ng_desired_capacity                = local.nodes.node_group.ng_desired_capacity
  ng_max_capacity                    = local.nodes.node_group.ng_max_capacity
  ng_min_capacity                    = local.nodes.node_group.ng_min_capacity
  node_group_name                    = local.nodes.node_group.node_group_name
  subnets                            = module.vpc.private_subnets_ids
  workers_instance_type              = local.nodes.workers_instance_type
  workers_max_unavailable_percentage = local.nodes.node_group.workers_max_unavailable_percentage
  workers_role_arn                   = module.eks.eks_worker_node_role_arn
  workers_security_group_id          = module.eks.eks_worker_node_security_group_id
}

module "eks-addons" {
  depends_on = [module.eks]
  source     = "./eks_addons"

  cluster_addons = {
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
  cluster_name = module.eks.eks_cluster_name
}

module "jump-host" {
  depends_on = [module.vpc]
  source     = "./ec2_jump_host"

  cluster_name              = module.eks.eks_cluster_name
  cluster_security_group_id = module.eks.eks_cluster_security_group_id
  instance_profile_name     = "${local.name_prefix}-jump-host"
  name_prefix               = local.name_prefix
  role_name                 = "${local.name_prefix}-jump-host"
  security_group_name       = "${local.name_prefix}-jump-host"
  subnets                   = split(",", module.vpc.private_subnets_ids)
  vpc_id                    = module.vpc.vpc_id
}

module "aws-auth" {
  count      = local.eks.access.aws_auth.manage_aws_auth_cm && contains(["CONFIG_MAP", "API_AND_CONFIG_MAP"], local.eks.access.access_config.authentication_mode) ? 1 : 0
  depends_on = [module.eks]
  source     = "./eks-aws-auth-configmap"

  aws_auth_roles = [
    {
      groups   = ["system:masters"]
      rolearn  = module.eks.eks_admin_users_role_arn
      username = "admin-users"
    },
    {
      groups   = ["system:masters"]
      rolearn  = module.jump-host.jump_host_iam_role_arn
      username = "admin-users"
    },
    {
      groups   = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
      rolearn  = module.eks.eks_worker_node_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
    }
  ]
  cluster_name    = module.eks.eks_cluster_name
  create_aws_auth = local.eks.access.aws_auth.create_aws_auth
}

module "eks-access-policies" {
  count  = local.eks.access.configure_api_access && contains(["API", "API_AND_CONFIG_MAP"], local.eks.access.access_config.authentication_mode) ? 1 : 0
  source = "./eks_access_policies"

  cluster_access_config_api = local.eks.access.cluster_access_config_api
  cluster_name              = module.eks.eks_cluster_name
}
