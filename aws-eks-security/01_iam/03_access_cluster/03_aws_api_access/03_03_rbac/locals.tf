locals {
  eks = {
    access = {
      access_config = {
        authentication_mode                         = "API"
        bootstrap_cluster_creator_admin_permissions = true
      }
      aws_auth = {
        create_aws_auth    = true
        manage_aws_auth_cm = true
      }
      cluster_access_config_api = [
        {
          association_access_scope_type = "cluster"
          association_policy_arn        = ""
          kubernetes_groups             = ["eks-test-rbac"]
          principal_arn                 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/secure-eks-jump-host"
          type                          = "STANDARD"
          user_name                     = "admin-users"
        },
        {
          association_access_scope_type = "cluster"
          association_policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          kubernetes_groups             = ["system:nodes"]
          principal_arn                 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/secure-eks-eks-worker-node-role"
          type                          = "EC2_LINUX"
          user_name                     = "system:node:{{EC2PrivateDNSName}}"
        },
        {
          association_access_scope_type = "cluster"
          association_policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          kubernetes_groups             = ["system:masters"]
          principal_arn                 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/eks-security-test-user"
          type                          = "STANDARD"
          user_name                     = "admin-users"
        }
      ]
      cluster_access_config_api_import = [
        {
          association_access_scope_type = "cluster"
          association_policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          kubernetes_groups             = ["system:nodes"]
          principal_arn                 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/secure-eks-eks-worker-node-role"
          type                          = "EC2_LINUX"
          user_name                     = "system:node:{{EC2PrivateDNSName}}"
        },
        {
          association_access_scope_type = "cluster"
          association_policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          kubernetes_groups             = ["system:masters"]
          principal_arn                 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/eks-security-test-user"
          type                          = "STANDARD"
          user_name                     = "admin-users"
        }
      ]
      cluster_endpoint_public_access_cidrs = [""]
      configure_access                     = true
      configure_api_access                 = true
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
  import_aws_eks_access_entries             = try(local.eks.access.cluster_access_config_api_import, null) != null ? [for x in local.eks.access.cluster_access_config_api_import : x] : []
  import_aws_eks_access_policy_associations = try(local.eks.access.cluster_access_config_api_import, null) != null ? [for x in local.eks.access.cluster_access_config_api_import : x if x.type == "STANDARD"] : []
}
