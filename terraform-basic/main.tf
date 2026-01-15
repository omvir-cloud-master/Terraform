resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev_vpc_tf"
  }
}


resource "aws_subnet" "dev_public_sub" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "dev_pub_sub_tf"
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_igw_tf"
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
  subnet_id      = aws_subnet.dev_public_sub.id
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


resource "aws_key_pair" "dev-auth" {
  key_name   = "dev-keypair"
  public_key = file("~/.ssh/dev-keypair.pub")
}

resource "aws_instance" "dev_server" {
  ami                    = "ami-02b8269d5e85954ef"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dev_public_sub.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  key_name               = aws_key_pair.dev-auth.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "dev-vm-tf"
    Env  = "dev"
  }



}

