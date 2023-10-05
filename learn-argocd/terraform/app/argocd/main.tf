# Install ArgoCD Helm release
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
    })
    : ""
    ],
    [
      <<EOT
  server:
    ingress:
      enabled: true
      ingressClassName: alb
      annotations:
        alb.ingress.kubernetes.io/certificate-arn: ${local.argocd.ingress.acm_cert_arn}
        alb.ingress.kubernetes.io/backend-protocol: HTTP
        alb.ingress.kubernetes.io/healthcheck-path: /
        alb.ingress.kubernetes.io/target-group-attributes: deregistration_delay.timeout_seconds=120
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-Ext-2018-06
        alb.ingress.kubernetes.io/target-type: ip
        alb.ingress.kubernetes.io/wafv2-acl-arn: ${local.argocd.ingress.waf_profile_arn}
        kubernetes.io/ingress.class: alb
      hosts:
      - ${var.argocd_ingress_host}
      https: true
EOT
    ]
  )

  # Use the predefined password
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt("Password!12244")
  }

  # Whether use Dex or not
  set {
    name  = "dex.enabled"
    value = var.enable_dex == true ? true : false
  }

  # Additional arguments for argocd
  set {
    name  = "server.extraArgs"
    value = "{${join(",", local.extra_args)}}"
  }

}

# Deploy argocd manifests with Helm
resource "helm_release" "crd_resources" {
  depends_on = [helm_release.argocd]
  chart            = "${path.module}/crd_helm"
  name             = "raw"


  # Helm chart deployment can sometimes take longer than the default 5 minutes
  timeout = var.timeout_seconds

  # Pass manifests as an array of manifests
  values = [
    <<-EOT
    resources:
    - apiVersion: argoproj.io/v1alpha1
      kind: Application
      metadata:
        name: app-of-apps
        namespace: argocd
      spec:
        destination:
         namespace: argocd
         server: https://kubernetes.default.svc
        project: in-cluster-apps
        source:
         path: apps
         repoURL: ${var.source_repo}
         targetRevision: "master"
        syncPolicy:
         automated:
           prune: true
           selfHeal: true
    - apiVersion: argoproj.io/v1alpha1
      kind: AppProject
      metadata:
        name: in-cluster-apps
        namespace: ${var.namespace}
      spec:
        clusterResourceWhitelist:
        - group: '*'
          kind: '*'
        destinations:
        - name: '*'
          namespace: '*'
          server: https://kubernetes.default.svc
        namespaceResourceWhitelist:
        - group: '*'
          kind: '*'
        sourceRepos:
%{~ for repo in var.argocd_repos }
        - ${repo}
%{~ endfor }
    - apiVersion: argoproj.io/v1alpha1
      kind: AppProject
      metadata:
        name: applications
        namespace: ${var.namespace}
      spec:
        clusterResourceWhitelist:
        - group: '*'
          kind: '*'
        destinations:
        - name: '*'
          namespace: '*'
          server: https://kubernetes.default.svc
        namespaceResourceWhitelist:
        - group: '*'
          kind: '*'
        sourceRepos:
        - '*'
EOT
    ]

}