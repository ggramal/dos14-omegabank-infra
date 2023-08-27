resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "gws" {
  for_each = var.internet_gws
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = each.value.name
  }
}

#resource "aws_nat_gateway" "nats" {
#  allocation_id = aws_eip.nats.id
#  subnet_id     = aws_subnet.main.id
#
#  tags = {
#    Name = "omega_nat1-tf"
#  }

#  #depends_on = [aws_internet_gateway.example]
#}

resource "aws_eip" "nats" {
  domain = "vpc"
}

resource "aws_subnet" "main" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.public_ip_on_launch
  availability_zone       = each.value.availability_zone

  tags = {
    Name = each.value.name
  }
}
#
#resource "aws_route_table" "example" {
#  vpc_id = aws_vpc.example.id
#
#  route {
#    cidr_block = "10.100.11.0/24"
#    gateway_id = aws_internet_gateway.example.id
#  }
#
#  route {
#    cidr_block    = "10.100.21.0/24"
#    nat_ateway_id = aws_internet_gateway.example.id
#  }
#
#  route {
#    cidr_block = "10.100.0.0/16"
#    gateway_id = "local"
#  }
#  tags = {
#    Name = "example"
#  }
#}
#
#resource "aws_route_table_association" "a" {
#  subnet_id      = aws_subnet.foo.id
#  route_table_id = aws_route_table.bar.id
#}
#