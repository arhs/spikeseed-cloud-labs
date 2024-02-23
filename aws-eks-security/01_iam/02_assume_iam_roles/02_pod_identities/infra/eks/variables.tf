variable "cluster_create_timeout" {
  type    = string
  default = "30m"
}

variable "cluster_delete_timeout" {
  type    = string
  default = "15m"
}

variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "cluster_log_retention_in_days" {
  type    = number
  default = 60
}

variable "cluster_name" {
  type = string
}

variable "cluster_update_timeout" {
  type    = string
  default = "60m"
}

variable "cluster_version" {
  type = string
}

variable "create_oidc_provider" {
  type    = bool
  default = false
}

variable "eks_cluster_role_name" {
  type = string
}

variable "enable_encryption" {
  type    = bool
  default = false
}

variable "encryption_config" {
  type = any
  default = {
    resources = ["secrets"]
  }
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "name_prefix" {
  type = string
}

variable "subnet_ids" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "workers_sg_allowed_cidrs" {
  type = list(string)
}
