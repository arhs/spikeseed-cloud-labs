data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_id
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}