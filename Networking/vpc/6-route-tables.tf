# Route Tables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "${var.vpc_name}_public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  route {
    ipv6_cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "${var.vpc_name}_private"
  }
}

# Route Table Associations for Public Subnets

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table Associations for Private Subnets

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}