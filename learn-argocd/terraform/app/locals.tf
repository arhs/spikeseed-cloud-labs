locals {
  argocd = {
    repos = [
      "https://aws.github.io/eks-charts",
      "https://kubernetes-sigs.github.io/external-dns",
      var.source_repo
    ]
    version = "5.46.6"
  }
  eks = {
    cluster_name = "${local.name_prefix}-cluster"
  }
  name_prefix = "argocd-demo"
}