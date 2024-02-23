data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.eks_cluster_name
}
