variable "oidc_provider_arn" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "cluster_name" {
  type = string
}
