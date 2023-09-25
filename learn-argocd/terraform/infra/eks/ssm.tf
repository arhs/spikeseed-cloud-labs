#resource "aws_ssm_parameter" "cluster_oidc_issuer_url" {
#  type      = "SecureString"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/oidc/issuer/url"
#  value     = aws_eks_cluster.this.identity.0.oidc.0.issuer
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "oidc_provider_arn" {
#  type      = "SecureString"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/oidc/provider/arn"
#  value     = aws_iam_openid_connect_provider.oidc_provider.arn
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "cluster_id" {
#  #checkov:skip=CKV2_AWS_34:SSM parameter encryption is not needed
#  type      = "String"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/cluster-id"
#  value     = aws_eks_cluster.this.id
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "endpoint" {
#  #checkov:skip=CKV2_AWS_34:SSM parameter encryption is not needed
#  type      = "String"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/endpoint"
#  value     = aws_eks_cluster.this.endpoint
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "admin_users_role" {
#  #checkov:skip=CKV2_AWS_34:SSM parameter encryption is not needed
#  type      = "String"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/admin-users-role"
#  value     = aws_iam_role.eks_admin_users_role.arn
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "eks_cluster_role" {
#  count = var.create_cluster_role ? 1 : 0
#  #checkov:skip=CKV2_AWS_34:SSM parameter encryption is not needed
#  type      = "String"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/eks-cluster-role"
#  value     = "${var.name_prefix}-eks-cluster-role"
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "eks_worker_node_role" {
#  #checkov:skip=CKV2_AWS_34:SSM parameter encryption is not needed
#  type      = "String"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/eks-worker-node-role"
#  value     = aws_iam_role.eks_worker_node_role.arn
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "eks_worker_node_security_group_id" {
#  #checkov:skip=CKV2_AWS_34:SSM parameter encryption is not needed
#  type      = "String"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/eks-worker-node-security-group-id"
#  value     = aws_security_group.workers.id
#  overwrite = true
#}
