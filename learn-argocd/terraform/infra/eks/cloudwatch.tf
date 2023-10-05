resource "aws_cloudwatch_log_group" "this" {
  #checkov:skip=CKV_AWS_158:Encryption not needed
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
}