resource "aws_eip" "nat" {
  count = var.single_nat_gateway ? 1 : length(var.public_subnets)

  domain = "vpc"
  tags = {
    Name = "${var.name}-nat-az${var.azs[count.index]}-eip"
  }
}

resource "aws_nat_gateway" "this" {
  count      = var.single_nat_gateway ? 1 : length(var.public_subnets)
  depends_on = [aws_internet_gateway.this]

  allocation_id = element(
    aws_eip.nat[*].id,
    var.single_nat_gateway ? 0 : count.index
  )
  subnet_id = element(
    aws_subnet.public[*].id,
    var.single_nat_gateway ? 0 : count.index
  )

  tags = {
    Name = "${var.name}-public-az${var.azs[count.index]}"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = length(var.private_subnets)

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(
    aws_nat_gateway.this[*].id,
    var.single_nat_gateway ? 0 : count.index
  )
  route_table_id = aws_route_table.private[count.index].id
  timeouts {
    create = "5m"
  }
}
