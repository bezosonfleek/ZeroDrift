resource "aws_vpc" "zero-drift-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "zero-drift-pub-subnet" {
  vpc_id     = aws_vpc.zero-drift-vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone
}

resource "aws_internet_gateway" "zero-drift-ig" {
  vpc_id = aws_vpc.zero-drift-vpc.id
  tags = {
    Name   = "${var.project_name}-ig"  
  }
}

resource "aws_route_table" "zero-drift-rt" {
  vpc_id = aws_vpc.zero-drift-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zero-drift-ig.id
  }
  
  tags = {
    Name = "${var.project_name}-rt"
  }
}

resource "aws_route_table_association" "zero-drift-rta" {
  subnet_id      = aws_subnet.zero-drift-pub-subnet.id
  route_table_id = aws_route_table.zero-drift-rt.id
}

resource "aws_security_group" "zero-drift-sg" {
  name = "${var.project_name}-sg"
  vpc_id = aws_vpc.zero-drift-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }   
}