resource "aws_vpc" "test-terraform-vpc" {
  cidr_block = "10.0.0.0/16" 
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-lab1"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.test-terraform-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-sb"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.test-terraform-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "private-sb"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  tags = {
    Name = "igw-lab1"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt-lab1"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  tags = {
    Name = "private-rt-lab1"
  }
}

resource "aws_route_table_association" "rt-as_public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "rt-as-private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public-sg" {
  vpc_id = aws_vpc.test-terraform-vpc.id

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
    Name = "public-sg"
  }
}

resource "aws_security_group" "private-sg" {
  vpc_id = aws_vpc.test-terraform-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.public-sg.id]
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

resource "aws_instance" "app" {
  ami = "ami-0b3c832b6b7289e44"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public-sg.id]
  key_name = "my-key-pair"

  associate_public_ip_address = true
  
  tags = {
    Name = "ec2-app-lab1"
  }
} 

resource "aws_instance" "db" {
  ami = "ami-0b3c832b6b7289e44"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  key_name = "my-key-pair"

  tags = {
    Name = "ec2-db-lab"
  }
}
