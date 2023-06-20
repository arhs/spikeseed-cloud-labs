variable "bucket_names" {
  type = list(string)
}

variable "lambda_arn" {
  type = string
}

variable "lambda_version" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "validation_record_fqdn" {
  type    = string
  default = null
}

variable "domain_name" {
  description = "The alternate domain name to associate with CloudFront"
  type        = string
}
