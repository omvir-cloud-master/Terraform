resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.pub_sub_az

  tags = {
    Name = var.pub_sub_name
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_sub_cidr
  map_public_ip_on_launch = false  
  availability_zone       = var.private_sub_az

  tags = {
    Name = var.private_sub_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_name
  }
}


resource "aws_route_table" "route_tb" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.rtb_name
  }
}

resource "aws_route" "route1" {
  route_table_id         = aws_route_table.route_tb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rt_asscoiation" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.route_tb.id
}

resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = "security group"
  vpc_id      = aws_vpc.vpc.id

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
    Name = var.sg_tag_name
  }
}