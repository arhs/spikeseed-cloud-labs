output "eks_cluster_certificate" {
  value = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_cluster_id" {
  value = aws_eks_cluster.this.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eks_cluster_security_group_arn" {
  value = aws_security_group.cluster.arn
}

output "eks_cluster_role_arn" {
  value = "${var.name_prefix}-eks-cluster-role"
}

output "eks_admin_users_role" {
  value = aws_iam_role.eks_admin_users_role.arn
}

output "eks_worker_node_role" {
  value = aws_iam_role.eks_worker_node_role.arn
}

output "eks_worker_node_security_group_id" {
  value = aws_security_group.workers.id
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}