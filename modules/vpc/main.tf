resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags                    = {
    Name = "public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_c_cidr
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags                    = {
    Name = "public-c"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "ap-northeast-1a"
  tags              = {
    Name = "private-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_c_cidr
  availability_zone = "ap-northeast-1c"
  tags              = {
    Name = "private-c"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags   = {
    Name = "main-gw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}

resource "aws_eip" "nat_1a" {
  tags = {
    Name = "nat-1a"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat_1a.id
  tags          = {
    Name = "nat-1a"
  }
}

resource "aws_eip" "nat_1c" {
  tags = {
    Name = "nat-1c"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  subnet_id     = aws_subnet.public_c.id
  allocation_id = aws_eip.nat_1c.id
  tags          = {
    Name = "nat-1c"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = {
    Name = "public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public_1a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "public_1c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_c.id
}

resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id
  tags   = {
    Name = "private-1a"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id
  tags   = {
    Name = "private-1c"
  }
}

resource "aws_route" "private_1a" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_1a.id
  nat_gateway_id         = aws_nat_gateway.nat_1a.id
}

resource "aws_route" "private_1c" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_1c.id
  nat_gateway_id         = aws_nat_gateway.nat_1c.id
}

resource "aws_route_table_association" "private_1a" {
  route_table_id = aws_route_table.private_1a.id
  subnet_id      = aws_subnet.private_a.id
}

resource "aws_route_table_association" "private_1c" {
  route_table_id = aws_route_table.private_1c.id
  subnet_id      = aws_subnet.private_c.id
}