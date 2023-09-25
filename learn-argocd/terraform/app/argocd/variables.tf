variable "private_repos_config" {
  type = list(
    object(
      {
        name     = string
        password = string
        project  = string
        type     = string
        url      = string
        username = string
      }
    )
  )
  default = []
  sensitive = true
}

variable "argocd_chart_version" {
  default     = "5.16.9" # See https://artifacthub.io/packages/helm/argo/argo-cd for latest version(s)
  description = "Version of ArgoCD chart to install"
  type        = string
}

variable "argocd_repos" {
  default     = []
  description = "A list of repos to be used with the installation"
  type        = list(string)
}

#variable "cluster_id" {
#  description = "The ID of the cluster where the ingress controller should be attached"
#  type        = string
#}
#
#variable "cluster_name" {
#  type = string
#}

variable "enable_dex" {
  default     = true
  description = "Enabled the dex server?"
  type        = bool
}

variable "extra_args" {
  type    = list(string)
  default = []
}

variable "insecure" {
  default     = false
  description = "Disable TLS on the ArogCD API Server? (adds the --insecure flag to the argocd-server command)"
  type        = bool
}

variable "namespace" {
  default     = "argocd"
  description = "Namespace to install ArgoCD chart into"
  type        = string
}

variable "password_allows_special" {
  default     = false
  description = "Define if the password can contains special characters"
  type        = bool
}

variable "password_length" {
  default     = 16
  description = "Define the length of the generated password"
  type        = number
}

variable "password_override_special" {
  default     = "@/"
  description = "Define the special characters allowed for the password generation"
  type        = string
}

variable "release_name" {
  type        = string
  description = "Helm release name"
  default     = "argocd"
}

#variable "ssm_prefix" {
#  description = "Define the prefix of the ssm to use on every resources"
#  type        = string
#}

variable "timeout_seconds" {
  default     = 600 # 10 minutes
  description = "Helm chart deployment can sometimes take longer than the default 5 minutes. Set a custom timeout here."
  type        = number
}

variable "values_file" {
  default     = "values.yaml"
  description = "The name of the ArgoCD helm chart values file to use"
  type        = string
}

#variable "waf_ssm" {
#  description = "SSM parameter with a WAF profile"
#  type        = string
#}

variable "source_repo" {
  type = string
}

variable "argocd_ingress_host" {
  type = string
}