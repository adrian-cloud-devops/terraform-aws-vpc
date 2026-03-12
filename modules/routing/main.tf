resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "main-igw"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, {
    Name = "public-route-table"
  })
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "private-route-table"
  })
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = var.public_subnet_a_id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = var.public_subnet_b_id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = var.private_subnet_a_id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = var.private_subnet_b_id
  route_table_id = aws_route_table.private_rt.id
}