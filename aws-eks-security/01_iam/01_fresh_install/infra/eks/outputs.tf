output "cluster_oidc_issuer_url" {
  value = var.create_oidc_provider ? aws_eks_cluster.this.identity[0].oidc[0].issuer : ""
}

output "eks_admin_users_role" {
  value = aws_iam_role.eks_admin_users_role.arn
}

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

output "eks_cluster_version" {
  value = aws_eks_cluster.this.version
}

output "eks_worker_node_role" {
  value = aws_iam_role.eks_worker_node_role.arn
}

output "eks_worker_node_security_group_id" {
  value = aws_security_group.workers.id
}

output "oidc_provider_arn" {
  value = var.create_oidc_provider ? aws_iam_openid_connect_provider.oidc_provider[0].arn : ""
}
