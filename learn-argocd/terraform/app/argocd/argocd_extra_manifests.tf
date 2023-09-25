#resource "kubernetes_manifest" "appproject_in_cluster_apps" {
#  depends_on = [helm_release.argocd]
#  manifest = {
#    "apiVersion" = "argoproj.io/v1alpha1"
#    "kind" = "AppProject"
#    "metadata" = {
#      "name" = "in-cluster-apps"
#      "namespace" = var.namespace
#    }
#    "spec" = {
#      "clusterResourceWhitelist" = [
#        {
#          "group" = "*"
#          "kind" = "*"
#        },
#      ]
#      "destinations" = [
#        {
#          "name" = "*"
#          "namespace" = "*"
#          "server" = "https://kubernetes.default.svc"
#        },
#      ]
#      "namespaceResourceWhitelist" = [
#        {
#          "group" = "*"
#          "kind" = "*"
#        },
#      ]
#      "sourceRepos" = var.argocd_repos
#    }
#  }
#}
#
#
#resource "kubernetes_manifest" "application_app_of_apps" {
#  depends_on = [helm_release.argocd]
#  manifest = {
#    "apiVersion" = "argoproj.io/v1alpha1"
#    "kind" = "Application"
#    "metadata" = {
#      "name" = "app-of-apps"
#      "namespace" = "argocd"
#    }
#    "spec" = {
#      "destination" = {
#        "namespace" = "argocd"
#        "server" = "https://kubernetes.default.svc"
#      }
#      "project" = "in-cluster-apps"
#      "source" = {
#        "path" = "apps"
#        "repoURL" = var.source_repo
#        "targetRevision" = "HEAD"
#      }
#      "syncPolicy" = {
#        "automated" = {
#          "prune" = true
#          "selfHeal" = true
#        }
#      }
#    }
#  }
#}
#
#resource "kubernetes_manifest" "appproject_applications" {
#  depends_on = [helm_release.argocd]
#  manifest = {
#    "apiVersion" = "argoproj.io/v1alpha1"
#    "kind" = "AppProject"
#    "metadata" = {
#      "name" = "applications"
#      "namespace" = var.namespace
#    }
#    "spec" = {
#      "clusterResourceWhitelist" = [
#        {
#          "group" = "*"
#          "kind" = "*"
#        },
#      ]
#      "destinations" = [
#        {
#          "name" = "*"
#          "namespace" = "*"
#          "server" = "https://kubernetes.default.svc"
#        },
#      ]
#      "namespaceResourceWhitelist" = [
#        {
#          "group" = "*"
#          "kind" = "*"
#        },
#      ]
#      "sourceRepos" = [
#        var.source_repo
#      ]
#    }
#  }
#}
