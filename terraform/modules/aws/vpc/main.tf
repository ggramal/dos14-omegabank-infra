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

resource "aws_nat_gateway" "nats" {
  allocation_id = aws_eip.nats.id
  subnet_id     = aws_subnet.main["public_subnet3"].id

  tags = {
    Name = "omega_nat1-tf"
  }

  #depends_on = [aws_internet_gateway.example]
}

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

resource "aws_route_table" "routes" {
  for_each = var.subnets
  vpc_id   = aws_vpc.main.id

  dynamic "route" {
    for_each = [
      for route in each.value.routes :
      route
      if route.internet_gw != null
    ]
    content {
      # cidr_block = route.value.cidr
      gateway_id = aws_internet_gateway.gws.id
    }
  }
}
#
#resource "aws_route_table_association" "a" {
#  subnet_id      = aws_subnet.foo.id
#  route_table_id = aws_route_table.bar.id
#}
#