variable "deletion_window_in_days" {
  default     = 30
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30"
  type        = number
}

variable "description" {
  default     = ""
  description = ""
  type        = string
}

variable "enable_key_rotation" {
  default     = true
  description = "Specifies whether annual key rotation is enabled"
  type        = bool
}

variable "is_enabled" {
  default     = true
  description = "Specifies whether the key is enabled"
  type        = bool
}

variable "key_name" {
  description = "Name of the key"
  type        = string
}

variable "policy" {
  description = "A valid KMS key policy JSON document. Although this is a key policy, not an IAM policy, an aws_iam_policy_document, in the form that designates a principal, can be used"
  type        = string
}

variable "ssm_prefix" {
  description = "Define the prefix of the name to use on every ssm parameters"
  type        = string
}


variable "name_prefix" {
  description = "Define the prefix of the name to use on every resources"
  type        = string
}

variable "cluster_name" {
  type = string
}