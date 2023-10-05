#data "aws_ssm_parameter" "vpc_id" {
#  name = var.ssm_vpc_id_key
#}

#data "aws_ssm_parameter" "subnets_id" {
#  name = var.ssm_subnets_key
#}

data "aws_default_tags" "aws_tags" {}