#data "aws_ssm_parameter" "oidc_provider_arn" {
#  name = var.ssm_oidc_provider_arn_key
#}
#
#data "aws_ssm_parameter" "cluster_oidc_issuer_url" {
#  name = var.ssm_cluster_oidc_issuer_url_key
#}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}