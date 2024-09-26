resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private_db_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "11.0.0.0/16"
    gateway_id = "local"
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.subnets.public)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_db_subnet_asso" {
  count          = length(var.subnets.private_db)
  subnet_id      = element(aws_subnet.private_db_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_db_rt.id
}
