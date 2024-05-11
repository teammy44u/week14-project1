resource "aws_vpc" "utc-app" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name
    env  = var.environment
    team = var.team
  }
}

resource "aws_internet_gateway" "utc-app-igw" {
  vpc_id = aws_vpc.utc-app.id
}

resource "aws_subnet" "public_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.utc-app.id
  availability_zone       = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
  cidr_block              = "10.10.${16 + 16 * count.index}.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  count             = 6
  vpc_id            = aws_vpc.utc-app.id
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index % 3) // Adjusted the index calculation
  cidr_block        = "10.10.${64 + 16 * count.index}.0/24"
}

resource "aws_eip" "nat-eip" {
  count = 2
}

resource "aws_nat_gateway" "utc-app-nat" {
  count         = 2
  subnet_id     = aws_subnet.public_subnet[count.index].id
  allocation_id = aws_eip.nat-eip[count.index].id
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.utc-app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.utc-app-igw.id
  }
}

resource "aws_route_table" "private_route" {
  count  = 2
  vpc_id = aws_vpc.utc-app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.utc-app-nat[count.index].id
  }
}

resource "aws_route_table_association" "public_route" {
  count          = 3
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table_association" "private_route" {
  count          = 6
  route_table_id = element(aws_route_table.private_route.*.id, floor(count.index / 3))
  subnet_id      = aws_subnet.private_subnet[count.index].id
}