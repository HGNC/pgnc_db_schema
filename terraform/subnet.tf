resource "aws_subnet" "public_subnets" {
  count             = length(var.subnets.public)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets.public[count.index].cidr
  availability_zone = var.subnets.public[count.index].az
  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_db_subnets" {
  count             = length(var.subnets.private_db)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets.private_db[count.index].cidr
  availability_zone = var.subnets.private_db[count.index].az
  tags = {
    Name = "Private DB Subnet ${count.index + 1}"
  }
}


