resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  availability_zone = local.az_names[count.index]
  cidr_block        = var.private_subnets[count.index]
  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "Name"                            = "${var.name}-private-az${var.azs[count.index]}",
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  tags = {
    Name = "${var.name}-private-az${var.azs[count.index]}"
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}
