locals {
  eks = {
    access = {
      access_config = {
        authentication_mode                         = "CONFIG_MAP"
        bootstrap_cluster_creator_admin_permissions = true
      }
      aws_auth = {
        create_aws_auth    = true
        manage_aws_auth_cm = true
      }
      cluster_endpoint_public_access_cidrs = [""]
      configure_access                     = true
    }
    cluster_name          = "${local.name_prefix}-cluster"
    cluster_version       = "1.29"
    eks_cluster_role_name = "${local.name_prefix}-eks-cluster-role"
  }
  name_prefix = "secure-eks"
  nodes = {
    node_group = {
      ng_ami_type                        = "AL2_x86_64"
      ng_desired_capacity                = "0"
      ng_max_capacity                    = "2"
      ng_min_capacity                    = "0"
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