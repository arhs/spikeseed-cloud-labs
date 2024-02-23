resource "kubernetes_config_map" "aws_auth" {
  count = var.create_aws_auth ? 1 : 0

  data = local.aws_auth_configmap_data
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  lifecycle {
    ignore_changes = [
      data,
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  count = var.create_aws_auth ? 0 : 1
  depends_on = [
    kubernetes_config_map.aws_auth,
  ]

  data  = local.aws_auth_configmap_data
  force = true
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}
