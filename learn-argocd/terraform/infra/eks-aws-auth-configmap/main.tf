resource "kubernetes_config_map_v1" "aws-auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  # force = true
  data = {
    mapRoles = yamlencode([
      {
        rolearn  = var.admin_users_role_arn
        username = "admin-users"
        groups   = ["system:masters"]
      },
      {
        rolearn  = var.worker_node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
      }
    ])
  }
}
