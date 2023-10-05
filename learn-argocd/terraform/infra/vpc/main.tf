locals {
  az_names = [for az in var.azs : "${data.aws_region.current.name}${az}"]
}

data "aws_region" "current" {}

############################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = var.name }
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.name}-vpc-default-unused" }
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = { Name = "${var.name}-default-unused" }
}

################################################################################
# Subnets
################################################################################

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "${var.name}-public-az${var.azs[count.index]}",
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = local.az_names[count.index]

  tags = {
    "Name"                            = "${var.name}-private-az${var.azs[count.index]}",
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "data_private" {
  count = length(var.data_subnets_cidr)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.data_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = { Name = "${var.name}-data-private-az${var.azs[count.index]}" }
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = { Name = var.name }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.name}-public-az" }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

################################################################################
# Private Network
################################################################################

resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.name}-private-az${var.azs[count.index]}" }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

################################################################################
# NAT Gateways
################################################################################

resource "aws_eip" "nat" {
  count = var.single_nat_gateway ? 1 : length(var.public_subnets)

  domain = "vpc"

  tags = { Name = "${var.name}-nat-az${var.azs[count.index]}-eip" }
}

resource "aws_nat_gateway" "this" {
  count      = var.single_nat_gateway ? 1 : length(var.public_subnets)
  depends_on = [aws_internet_gateway.this]

  allocation_id = element(
    aws_eip.nat.*.id,
    var.single_nat_gateway ? 0 : count.index
  )
  subnet_id = element(
    aws_subnet.public.*.id,
    var.single_nat_gateway ? 0 : count.index
  )

  tags = { Name = "${var.name}-public-az${var.azs[count.index]}" }
}

resource "aws_route" "private_nat_gateway" {
  count = length(var.private_subnets)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(
    aws_nat_gateway.this.*.id,
    var.single_nat_gateway ? 0 : count.index
  )

  timeouts {
    create = "5m"
  }
}

##================
## Flow logs
##================
#
#resource "aws_flow_log" "main" {
#  iam_role_arn    = aws_iam_role.aws_flow_log_role.arn
#  log_destination = aws_cloudwatch_log_group.this.arn
#  traffic_type    = "ALL"
#  vpc_id          = aws_vpc.this.id
#}
#
#resource "aws_cloudwatch_log_group" "this" {
#  #checkov:skip=CKV_AWS_158:encryption is not needed
#  name              = "/aws/vpc-flow-logs/${var.name_prefix}-vpc"
#  retention_in_days = var.log_retention_in_days
#}
#
#resource "aws_iam_role" "aws_flow_log_role" {
#  name = "${var.name_prefix}-vpc-flow-log"
#
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "",
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "vpc-flow-logs.amazonaws.com"
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy" "aws_flow_log_policy" {
#  name = "${var.name_prefix}-vpc-flow-log-policy"
#  role = aws_iam_role.aws_flow_log_role.id
#
#  policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": [
#        "logs:CreateLogGroup",
#        "logs:CreateLogStream",
#        "logs:PutLogEvents",
#        "logs:DescribeLogGroups",
#        "logs:DescribeLogStreams"
#      ],
#      "Effect": "Allow",
#      "Resource": "*"
#    }
#  ]
#}
#EOF
#}
#
##================
## Parameters
##================
#
#resource "aws_ssm_parameter" "vpc_id" {
#  name      = "/${var.ssm_prefix}/network/vpc-id"
#  type      = "String"
#  value     = aws_vpc.vpc.id
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "vpc_cidr" {
#  name      = "/${var.ssm_prefix}/network/vpc-cidr"
#  type      = "String"
#  value     = var.vpc_cidr
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "public_subnet_az1" {
#  name      = "/${var.ssm_prefix}/network/subnets/public-subnet-az1-id"
#  type      = "String"
#  value     = aws_subnet.public_subnet_az1.id
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "public_subnet_az2" {
#  name      = "/${var.ssm_prefix}/network/subnets/public-subnet-az2-id"
#  type      = "String"
#  value     = aws_subnet.public_subnet_az2.id
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "public_subnet_az3" {
#  name      = "/${var.ssm_prefix}/network/subnets/public-subnet-az3-id"
#  type      = "String"
#  value     = aws_subnet.public_subnet_az3.id
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "public_subnets" {
#  name      = "/${var.ssm_prefix}/network/subnets/public-subnets"
#  type      = "String"
#  value     = "${aws_subnet.public_subnet_az1.id},${aws_subnet.public_subnet_az2.id}"
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "public_subnets_arn" {
#  name      = "/${var.ssm_prefix}/network/subnets/public-subnets-arn"
#  type      = "String"
#  value     = "${aws_subnet.public_subnet_az1.arn},${aws_subnet.public_subnet_az2.arn}"
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "private_subnet_az1" {
#  name      = "/${var.ssm_prefix}/network/subnets/private-subnet-az1-id"
#  type      = "String"
#  value     = aws_subnet.private_subnet_az1.id
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "private_subnet_az2" {
#  name      = "/${var.ssm_prefix}/network/subnets/private-subnet-az2-id"
#  type      = "String"
#  value     = aws_subnet.private_subnet_az2.id
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "private_subnet_az3" {
#  name      = "/${var.ssm_prefix}/network/subnets/private-subnet-az3-id"
#  type      = "String"
#  value     = aws_subnet.private_subnet_az3.id
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "private_subnets" {
#  name      = "/${var.ssm_prefix}/network/subnets/private-subnets"
#  type      = "String"
#  value     = "${aws_subnet.private_subnet_az1.id},${aws_subnet.private_subnet_az2.id},${aws_subnet.private_subnet_az3.id}"
#  overwrite = true
#}
#
#resource "aws_ssm_parameter" "private_subnets_arn" {
#  name      = "/${var.ssm_prefix}/network/subnets/private-subnets-arn"
#  type      = "String"
#  value     = "${aws_subnet.private_subnet_az1.arn},${aws_subnet.private_subnet_az2.arn},${aws_subnet.private_subnet_az3.arn}"
#  overwrite = true
#}