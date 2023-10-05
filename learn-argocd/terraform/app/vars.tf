variable "argocd_domain_name" {
  description = "ArgoCD DNS name"
  type        = string
}

variable "private_repos_config" {
  default     = []
  description = "A list of private repos to use with ArgoCD"
  type = list(object({
    name     = string
    password = string
    project  = string
    type     = string
    url      = string
    username = string
  }))
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "source_repo" {
  default     = ""
  description = "A source repository address for ArgoCD configuration"
  type        = string
}