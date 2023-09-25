variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "data_subnets_cidr" {
  type    = list(string)
  default = []
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

#variable "ssm_vpc_id_key" {
#  type = string
#}
#
#variable "ssm_public_subnets_id_key" {
#  type = string
#}

#variable "ssm_private_subnets_id_key" {
#  type = string
#}
#
#variable "ssm_vpc_cidr" {
#  type = string
#}
#
#variable "ssm_vpc_rt_list" {
#  type = string
#}
#
#variable "logs_bucket_name" {
#  type = string
#}

#variable "vpc_flow_logs_prefix" {
#  type = string
#}

#variable "vpc_query_logs_prefix" {
#  type = string
#}
