terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region     = "ap-south-2"
}

#creating vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tf-vpc"
  }
}

#creating public subnet 
resource "aws_subnet" "sub-1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "tf-pub-sub-1"
  }
}

resource "aws_subnet" "sub-2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "tf-pub-sub-2"
  }
}

#Creating Private subnet
resource "aws_subnet" "sub-3" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "tf-priv-sub-1"
  }
}

resource "aws_subnet" "sub-4" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "tf-priv-sub-2"
  }
}

#creating internet gateway and attached to vpc
resource "aws_internet_gateway" "gw-1" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "tf-igw"
  }
}

#creating Public Route tables 
resource "aws_route_table" "rtb1" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "tf-pub-rtb"
  }
}

resource "aws_route_table" "rtb2" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "tf-priv-rtb"
  }
}


resource "aws_route_table_association" "pub-1" {
  subnet_id      = aws_subnet.sub-1.id
  route_table_id = aws_route_table.rtb1.id
}

resource "aws_route_table_association" "pub-2" {
  subnet_id      = aws_subnet.sub-2.id
  route_table_id = aws_route_table.rtb1.id
}


resource "aws_route_table_association" "priv-1" {
  subnet_id      = aws_subnet.sub-3.id
  route_table_id = aws_route_table.rtb2.id
}

resource "aws_route_table_association" "priv-2" {
  subnet_id      = aws_subnet.sub-4.id
  route_table_id = aws_route_table.rtb2.id
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.rtb1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw-1.id
}


