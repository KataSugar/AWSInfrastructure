resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "main-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "public-subnet-a"
    Environment = var.environment
  }
}

# resource "aws_subnet" "subnet_b" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "eu-west-3b"
#   map_public_ip_on_launch = false
# }