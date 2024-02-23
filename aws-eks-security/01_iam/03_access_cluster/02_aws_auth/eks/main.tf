resource "aws_eks_cluster" "this" {
  name                      = var.cluster_name
  enabled_cluster_log_types = var.cluster_enabled_log_types
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  version                   = var.cluster_version

  dynamic "encryption_config" {
    for_each = var.enable_encryption ? [var.encryption_config] : []
    content {
      provider {
        key_arn = encryption_config.value.kms_key_arn
      }
      resources = encryption_config.value.resources
    }
  }

  dynamic "access_config" {
    for_each = var.configure_access ? [var.access_configuration] : []
    content {
      authentication_mode                         = try(access_config.value.authentication_mode, "CONFIG_MAP")
      bootstrap_cluster_creator_admin_permissions = try(access_config.value.bootstrap_cluster_creator_admin_permissions, true)
    }
  }

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
    security_group_ids = [
      aws_security_group.cluster.id
    ]
    subnet_ids = split(",", var.subnet_ids)
  }

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
    update = var.cluster_update_timeout
  }

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_security_group_rule.cluster_egress_internet,
    aws_security_group_rule.cluster_ingress_workers
  ]
}