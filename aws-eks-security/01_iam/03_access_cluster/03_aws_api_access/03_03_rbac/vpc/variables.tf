variable "azs" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "private_subnets" {
  default = []
  type    = list(string)
}

variable "public_subnets" {
  default = []
  type    = list(string)
}

variable "single_nat_gateway" {
  default = true
  type    = bool
}

variable "vpc_cidr" {
  type = string
}
