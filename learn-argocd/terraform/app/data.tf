data "aws_eks_cluster" "cluster" {
  name = local.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.eks.cluster_name
}

data "aws_caller_identity" "current" {}
