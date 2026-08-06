###################################
# Creating VPC 
###################################

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.environment}"
  }
}


#####################################
# PUBLIC SUBNET
####################################

resource "aws_subnet" "public_sub" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.pub_sub_az[count.index]
  tags = {
    Name = "pub-sub-${var.environment}-${count.index + 1}"
  }
}

####################################
# Private Subnet
####################################

resource "aws_subnet" "private_sub" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_sub_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.private_sub_az[count.index]
  tags = {
    Name = "private-sub-${var.environment}-${count.index + 1}"
  }
}

######################################################
# Database Subnets
######################################################

resource "aws_subnet" "db_sub" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.db_sub_cidr[count.index]
  availability_zone = var.db_sub_az[count.index]
  tags = {
    Name = "db-subnet-${var.environment}-${count.index + 1}"
  }
}

############################################
# Internet Gateway
############################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-${var.environment}"
  }
}


########################################
# Public Route Table
#######################################

resource "aws_route_table" "pub_route_tb" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "pub-rtb-${var.environment}"
  }
}

resource "aws_route" "route1" {
  route_table_id         = aws_route_table.pub_route_tb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "pub_rt_asscoiation" {
  count          = length(aws_subnet.public_sub)
  subnet_id      = aws_subnet.public_sub[count.index].id
  route_table_id = aws_route_table.pub_route_tb.id
}

########################################################
#Allocate an Elastic IP
########################################################
resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "nat-eip-${var.environment}"
  }

  depends_on = [aws_internet_gateway.igw]
}

##########################################################
#Create NAT Gateway
##########################################################
resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_sub[0].id

  tags = {
    Name = "nat-gateway-${var.environment}"
  }

  depends_on = [aws_internet_gateway.igw]
}


######################################################
# Private Route Table
######################################################
resource "aws_route_table" "priv_route_tb" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "priv-rtb-${var.environment}"
  }
}

resource "aws_route" "route2" {
  route_table_id         = aws_route_table.priv_route_tb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "priv_rt_asscoiation" {
  count          = length(aws_subnet.private_sub)
  subnet_id      = aws_subnet.private_sub[count.index].id
  route_table_id = aws_route_table.priv_route_tb.id
}

######################################################
# DB Route Table Association
######################################################

resource "aws_route_table_association" "db_rt_association" {
  count          = length(aws_subnet.db_sub)
  subnet_id      = aws_subnet.db_sub[count.index].id
  route_table_id = aws_route_table.priv_route_tb.id
}


########################################################
# Secutiry Groups
######################################################

resource "aws_security_group" "frontend_sg" {
  name        = "frontend-ec2-${var.environment}-sg"
  description = "Frontend security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   ingress {
  #     description = "allow HTTP"
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }

  #   ingress {
  #     description = "allow HTTPS"
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }

  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-ec2-${var.environment}-sg"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "backend-ec2-${var.environment}-sg"
  description = "Backend Security Group"
  vpc_id      = aws_vpc.vpc.id

  # SSH (only for demo purposes)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP in production
  }

  # Backend Application Port
  ingress {
    description = "Allow Application Traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"

    security_groups = [
      aws_security_group.frontend_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-ec2-${var.environment}-sg"
  }
}


resource "aws_security_group" "alb_sg" {
  name        = "alb-${var.environment}-sg"
  description = "Application Load Balancer Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-${var.environment}-sg"
  }
}


##################################################
# RDS SG
##################################################

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${var.environment}"
  description = "Allow MySQL from Backend EC2"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-${var.environment}"
  }
}
