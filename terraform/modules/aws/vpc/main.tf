resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.100.11.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "string"

  tags = {
    Name = "omega_igw1_tf"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "10.100.11.0/24"
    gateway_id = aws_internet_gateway.example.id
  }

  route {
    cidr_block    = "10.100.21.0/24"
    nat_ateway_id = aws_internet_gateway.example.id
  }

  route {
    cidr_block = "10.100.0.0/16"
    gateway_id = "local"
  }
  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.foo.id
  route_table_id = aws_route_table.bar.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "gw NAT"
  }

  #depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "lb" {
  domain = "vpc"
}