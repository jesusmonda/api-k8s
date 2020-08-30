// VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.project_name}_eks-cluster" = "owned"
    Name                                                    = "${var.project_name}"
  }
}

// SUBNET PRIVATE
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.1.0/24"

  tags = {
    "kubernetes.io/cluster/${var.project_name}_eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                       = "1"
    Name                                                    = "${var.project_name}_private"
  }
}
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "eu-west-1b"
  cidr_block        = "10.0.2.0/24"

  tags = {
    "kubernetes.io/cluster/${var.project_name}_eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                       = "1"
    Name                                                    = "${var.project_name}_private"
  }
}
resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "eu-west-1c"
  cidr_block        = "10.0.3.0/24"

  tags = {
    "kubernetes.io/cluster/${var.project_name}_eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                       = "1"
    Name                                                    = "${var.project_name}_private"
  }
}

// SUBNET PUBLIC
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "eu-west-1a"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.project_name}_eks-cluster" = "shared"
    "kubernetes.io/role/elb"                                = "1"
    Name                                                    = "${var.project_name}_public",
  }
}
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "eu-west-1b"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.project_name}_eks-cluster" = "shared"
    "kubernetes.io/role/elb"                                = "1"
    Name                                                    = "${var.project_name}_public",
  }
}
resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "eu-west-1c"
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.project_name}_eks-cluster" = "shared"
    "kubernetes.io/role/elb"                                = "1"
    Name                                                    = "${var.project_name}_public",
  }
}

// ROUTE TABLES PRIVATE
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}_private"
  }
}
// ROUTE TABLES PUBLIC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}_public"
  }
}
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.public.id
}

// ROUTE TABLES SUBNET PRIVATE
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private.id
}

// ROUTE TABLES SUBNET PUBLIC
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}

//NAT GATEWAY
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id
}

// INTERNET GATEWAY
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}"
  }
}