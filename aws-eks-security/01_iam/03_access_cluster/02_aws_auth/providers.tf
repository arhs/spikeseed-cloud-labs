provider "kubernetes" {
  cluster_ca_certificate = module.eks.eks_cluster_certificate
  host                   = module.eks.eks_cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
}
