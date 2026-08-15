resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

# ==================================================
# Internet Gateway
# ==================================================

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "terraform-igw"
  }
}

# ==================================================
# Public Subnets
# ==================================================

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet-2"
  }
}

# ==================================================
# Private Subnets
# ==================================================

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr_1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "terraform-private-subnet-1"

    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false

  tags = {
    Name = "terraform-private-subnet-2"

    "kubernetes.io/role/internal-elb" = "1"
  }
}

# ==================================================
# Public Route Table
# ==================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "terraform-public-route-table"
  }
}

# ==================================================
# Public Route Table Associations
# ==================================================

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# ==================================================
# Elastic IPs for NAT Gateways
# ==================================================

resource "aws_eip" "nat_1" {
  domain = "vpc"

  tags = {
    Name = "terraform-nat-eip-1"
  }
}

resource "aws_eip" "nat_2" {
  domain = "vpc"

  tags = {
    Name = "terraform-nat-eip-2"
  }
}

# ==================================================
# NAT Gateways
# ==================================================

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public_1.id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "terraform-nat-gateway-1"
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public_2.id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "terraform-nat-gateway-2"
  }
}

# ==================================================
# Private Route Tables
# ==================================================

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "terraform-private-route-table-1"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }

  tags = {
    Name = "terraform-private-route-table-2"
  }
}

# ==================================================
# Private Route Table Associations
# ==================================================

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}