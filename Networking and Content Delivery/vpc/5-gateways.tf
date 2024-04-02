# Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.vpc_name
  }
}

# EIP

resource "aws_eip" "vpc" {
  domain   = "vpc"

    tags = {
    Name = var.vpc_name
  }
}

# Nat Gateway

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.vpc.id
  subnet_id     = aws_subnet.public[0].id  # Using the first public subnet for NAT Gateway

  tags = {
    Name = var.vpc_name
  }

  depends_on = [aws_internet_gateway.gw]
}