locals {
  eks = {
    cluster_name          = "${local.name_prefix}-cluster"
    cluster_version       = "1.29"
    eks_cluster_role_name = "${local.name_prefix}-eks-cluster-role"
  }
  name_prefix = "secure-eks"
  nodes = {
    node_group = {
      ng_ami_type                        = "AL2_x86_64"
      ng_desired_capacity                = "1"
      ng_max_capacity                    = "2"
      ng_min_capacity                    = "1"
      node_group_name                    = "${local.name_prefix}-ng"
      workers_max_unavailable_percentage = "50"
    }
    workers_instance_type = "m5.large"
  }
  vpc = {
    azs             = ["a", "b"]
    name            = local.name_prefix
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets  = ["10.0.4.0/24", "10.0.5.0/24"]
    vpc_cidr        = "10.0.0.0/16"
  }
}

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

  cluster_name             = local.eks.cluster_name
  cluster_version          = local.eks.cluster_version
  eks_cluster_role_name    = local.eks.eks_cluster_role_name
  name_prefix              = local.name_prefix
  subnet_ids               = module.vpc.private_subnets_ids
  vpc_id                   = module.vpc.vpc_id
  workers_sg_allowed_cidrs = [module.vpc.vpc_cidr]
}

module "eks-ng" {
  depends_on = [module.eks]
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
  workers_role_arn                   = module.eks.eks_worker_node_role
  workers_security_group_id          = module.eks.eks_worker_node_security_group_id
}
