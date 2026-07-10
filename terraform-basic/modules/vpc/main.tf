resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.my_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.my_vpc_name
  }
}


resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.my_pub_sub_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.my_pub_sub_az

  tags = {
    Name = var.my_pub_sub_name
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.my_private_sub_cidr
  map_public_ip_on_launch = false  
  availability_zone       = var.my_private_sub_az

  tags = {
    Name = var.my_private_sub_name
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = var.my_igw_name
  }
}


resource "aws_route_table" "dev_route_tb" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_public_rt_tf"
  }
}

resource "aws_route" "dev_route1" {
  route_table_id         = aws_route_table.dev_route_tb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_igw.id
}

resource "aws_route_table_association" "dev_rt_asscoiation" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.dev_route_tb.id
}

resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev"
  }
}