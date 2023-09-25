resource "aws_eks_cluster" "this" {
  name                      = var.cluster_name
  enabled_cluster_log_types = var.cluster_enabled_log_types
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  version                   = var.cluster_version

  encryption_config {
    provider {
      key_arn = module.kms.key_arn
    }
    resources = ["secrets"]
  }

  vpc_config {
    security_group_ids = [
      aws_security_group.cluster.id
    ]
    subnet_ids              = split(",", var.subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
    update = var.cluster_update_timeout
  }

  depends_on = [
    aws_security_group_rule.cluster_egress_internet,
    aws_security_group_rule.cluster_ingress_workers,
    aws_cloudwatch_log_group.this
  ]
}

module "kms" {
  source                = "../kms"
  cluster_name          = var.cluster_name
  key_name              = "${var.name_prefix}-kms"
  name_prefix           = var.name_prefix
  policy                = var.kms_policy
  ssm_prefix            = var.ssm_prefix
}