resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.main.id
}
resource "aws_security_group" "main" {
  name        = "main"
  description = "Allow ssh access"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_egress_rule" "main" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    Name = "main"
  }
}

resource "aws_vpc_security_group_ingress_rule" "outside" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    Name = "main"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inside" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = "-1"
  cidr_ipv4         = aws_vpc.main.cidr_block
  tags = {
    Name = "main"
  }
}