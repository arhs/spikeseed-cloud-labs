# Generate the admin password
resource "random_password" "master_password" {
  length           = var.password_length
  special          = var.password_allows_special
  override_special = var.password_override_special
}
# Put the password value in the SSM parameter
resource "aws_ssm_parameter" "master_password" {
  name        = "/${var.ssm_prefix}/${var.cluster_id}/argocd/master_password"
  type        = "SecureString"
  value       = random_password.master_password.result
  description = "The password of the master used of the ArgoCD"
  overwrite   = true
}
# Install ArgoCD
resource "helm_release" "argocd" {
  chart            = "argo-cd"
  create_namespace = true
  name             = var.release_name
  namespace        = var.namespace
  repository       = "https://argoproj.github.io/argo-helm"
  version          = var.argocd_chart_version

  # Helm chart deployment can sometimes take longer than the default 5 minutes
  timeout = var.timeout_seconds

  # If values file specified by the var.values_file input variable exists then apply the values from this file
  # else apply the default values from the chart
  values = concat([
    fileexists("${path.module}/${var.values_file}") == true
    ? templatefile("${path.module}/${var.values_file}",
      {
        repos     = var.private_repos_config
        role_arn  = aws_iam_role.argocd.arn
    })
    : ""
    ],
    [
      <<EOT
  server:
    ingress:
      enabled: true
      annotations:
        alb.ingress.kubernetes.io/backend-protocol: HTTP
        alb.ingress.kubernetes.io/healthcheck-path: /
        alb.ingress.kubernetes.io/target-group-attributes: deregistration_delay.timeout_seconds=120
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-Ext-2018-06
        alb.ingress.kubernetes.io/target-type: ip
        kubernetes.io/ingress.class: alb
      hosts:
      - somehost
      https: true

EOT
    ]
  )

  # Use the generated password
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(random_password.master_password.result)
  }

  set {
    name  = "dex.enabled"
    value = var.enable_dex == true ? true : false
  }

  set {
    name  = "server.extraArgs"
    value = "{${join(",", local.extra_args)}}"
  }

  set {
    name = "server.service.type"
    value = "LoadBalancer"
  }

}
