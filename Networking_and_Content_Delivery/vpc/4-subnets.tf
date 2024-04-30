# Public Subnets

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(var.azs, count.index % length(var.azs))

  tags = {
    Name = "${var.vpc_name}-public-${element(var.azs, count.index % length(var.azs))}"
  }
}

# Private Subnets

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index % length(var.azs))

  tags = {
    Name = "${var.vpc_name}-private-${element(var.azs, count.index % length(var.azs))}"
  }
}
