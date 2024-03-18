variable "aws_auth_accounts" {
  default     = []
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
}

variable "aws_auth_roles" {
  default     = []
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
}

variable "aws_auth_users" {
  default     = []
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
}

variable "create_aws_auth" {
  default = true
  type    = bool
}
