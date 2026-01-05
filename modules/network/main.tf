resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "vpc_lab2"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.avaliablezone 
  map_public_ip_on_launch = true 

  tags = {
    Name = "public-sb"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.avaliablezone

  tags = {
    Name = "private-sb"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw-lab2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt-lab2"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private-rt-lab2"
  }
}

resource "aws_route_table_association" "public-as" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-as" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg-lab2"
  }
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}
