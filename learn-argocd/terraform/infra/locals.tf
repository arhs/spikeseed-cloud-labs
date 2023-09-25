locals {
  cluster_iam_role_name        = var.iam_role_name == null ? "${local.name_prefix}-eks-cluster-role" : var.iam_role_name
  cluster_iam_role_pathed_arn  = var.create_iam_role ? "arn:${local.context.aws_partition_id}:iam::${local.context.aws_caller_identity_account_id}:role/${local.cluster_iam_role_pathed_name}" : var.iam_role_arn
  cluster_iam_role_pathed_name = var.iam_role_path == null ? local.cluster_iam_role_name : "${trimprefix(var.iam_role_path, "/")}${local.cluster_iam_role_name}"
  dns = {
    application_domain_name = "nginx-demo.labs.spikeseed.cloud"
    argocd_domain_name      = "argocd-demo.labs.spikeseed.cloud"
  }
  context = {
    aws_caller_identity_account_id = data.aws_caller_identity.current.account_id
    aws_caller_identity_arn        = data.aws_caller_identity.current.arn
    aws_partition_dns_suffix       = data.aws_partition.current.dns_suffix
    aws_partition_id               = data.aws_partition.current.id
    aws_region_name                = data.aws_region.current.name
  }
  eks = {
    cluster_endpoint_public_access_cidrs = ["212.24.219.214/32"]
    cluster_name                         = "${local.name_prefix}-cluster"
    cluster_version                      = "1.27"
    eks_cluster_role_name                = "${local.name_prefix}-eks-cluster-role"
  }
  name_prefix = "argocd-demo"
  nodes = {
    node_group = {
      ng_ami_type                        = "AL2_x86_64"
      ng_desired_capacity                = "1"
      ng_max_capacity                    = "2"
      ng_min_capacity                    = "1"
      node_group_name                    = "${local.name_prefix}-ng"
      workers_max_unavailable_percentage = "50"
    }
    workers_instance_type = "t3.large"
  }
  ssm_prefix = "argocd-demo"
  vpc = {
    azs             = ["a", "b", "c"]
    name            = "argocd-demo"
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    vpc_cidr        = "10.0.0.0/16"
  }
}