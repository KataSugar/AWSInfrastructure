
#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "main-igw"
    Environment = var.environment
  }
}

# #NAT, elasticIP
# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.subnet_a.id 
#   depends_on    = [aws_internet_gateway.igw]
# }

# #route table to private subnet
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }
# }

# resource "aws_route_table_association" "private_a" {
#   subnet_id      = aws_subnet.subnet_b.id
#   route_table_id = aws_route_table.private.id
# }

#route table to public subnet
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public.id
}



# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  name   = "ec2-backend-sg"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #or specific IP/32
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-backend-sg"
  }
}