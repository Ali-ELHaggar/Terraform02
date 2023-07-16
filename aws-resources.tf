
resource "aws_subnet" "subnet-public" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

    tags = {
    Name = "subnet-public"
  }

}

resource "aws_subnet" "subnet-private" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet-private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "vpc_igw"
  }
}
# Create an Elastic IP for the NAT gateway
resource "aws_eip" "my_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.subnet-public.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }

  tags = {
    Name = "private_rt"
  }
}
resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.subnet-public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_asso" {
  subnet_id      = aws_subnet.subnet-private.id
  route_table_id = aws_route_table.private_rt.id
}
