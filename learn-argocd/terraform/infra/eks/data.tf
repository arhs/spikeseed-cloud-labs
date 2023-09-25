data "tls_certificate" "cluster" {
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

data "aws_caller_identity" "current" {}

#data "aws_iam_role" "eks_cluster_role" {
#  name = var.eks_cluster_role_name
#}