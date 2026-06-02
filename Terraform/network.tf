resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "minha vpc"
  }
}

resource "aws_route_table" "rtrp" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "controle de rede publica"
  }
}


resource "aws_subnet" "my-sbp" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "minha rede publica 1a"
  }
}


resource "aws_subnet" "my-sbp-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "minha rede publica 1b"
  }
}


resource "aws_route_table_association" "asr" {
  subnet_id      = aws_subnet.my-sbp.id
  route_table_id = aws_route_table.rtrp.id
}


resource "aws_route_table_association" "asr-2" {
  subnet_id      = aws_subnet.my-sbp-2.id
  route_table_id = aws_route_table.rtrp.id
}