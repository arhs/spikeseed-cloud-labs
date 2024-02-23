variable "access_configuration" {
  default = {}
  type    = any
}

variable "cluster_create_timeout" {
  default = "30m"
  type    = string
}

variable "cluster_delete_timeout" {
  default = "15m"
  type    = string
}

variable "cluster_enabled_log_types" {
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  type    = list(string)
}

variable "cluster_endpoint_public_access_cidrs" {
  default = ["0.0.0.0/0"]
  type    = list(string)
}

variable "cluster_log_retention_in_days" {
  default = 60
  type    = number
}

variable "cluster_name" {
  type = string
}

variable "cluster_update_timeout" {
  default = "60m"
  type    = string
}

variable "cluster_version" {
  type = string
}

variable "configure_access" {
  default = false
  type    = bool
}

variable "create_oidc_provider" {
  default = false
  type    = bool
}

variable "eks_cluster_role_name" {
  type = string
}

variable "enable_encryption" {
  default = false
  type    = bool
}

variable "encryption_config" {
  default = {
    resources = ["secrets"]
  }
  type = any
}

variable "endpoint_private_access" {
  default = true
  type    = bool
}

variable "endpoint_public_access" {
  default = true
  type    = bool
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
