variable "region" {
  description = "AWS region"
  type = string
}

variable "create_iam_role" {
  default     = true
  description = "Determines whether a an IAM role is created or to use an existing IAM role"
  type        = bool
}

variable "dns_zone_id" {
  description = "Id of the managed DNS zone"
  type = string
}
variable "iam_role_path" {
  default     = null
  description = "Cluster IAM role path"
  type        = string
}

variable "iam_role_name" {
  default     = null
  description = "Name to use on IAM role created"
  type        = string
}

variable "iam_role_arn" {
  default     = null
  description = "Existing IAM role ARN for the cluster. Required if `create_iam_role` is set to `false`"
  type        = string
}

variable "cluster_kms_key_additional_admin_arns" {
  default     = []
  description = "A list of additional IAM ARNs that should have FULL access (kms:*) in the KMS key policy"
  type        = list(string)
}