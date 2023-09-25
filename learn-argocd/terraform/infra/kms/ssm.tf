#resource "aws_ssm_parameter" "kms_key_id" {
#  #checkov:skip=CKV2_AWS_34
#  name  = "/${var.ssm_prefix}/kms/id"
#  type  = "String"
#  value = aws_kms_key.this.key_id
#}
#
#resource "aws_ssm_parameter" "kms_key_arn" {
#  #checkov:skip=CKV2_AWS_34
#  name  = "/${var.ssm_prefix}/kms/arn"
#  type  = "String"
#  value = aws_kms_key.this.arn
#}
#
#resource "aws_ssm_parameter" "eks_cluster_role" {
#  #checkov:skip=CKV2_AWS_34:SSM parameter encryption is not needed
#  type      = "String"
#  name      = "/${var.ssm_prefix}/${var.cluster_name}/eks-cluster-role"
#  value     = "${var.name_prefix}-eks-cluster-role"
#  overwrite = true
#}