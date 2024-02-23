locals {
  az_names = [for az in var.azs : "${data.aws_region.current.name}${az}"]
}
