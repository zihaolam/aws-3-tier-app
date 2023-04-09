resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.PROJECT_NAME}-vpc"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = "${var.PROJECT_NAME}-igw"
    Environment = var.PROJECT_NAME
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc                  = true
  network_border_group = var.network_border_group
  instance             = aws_instance.nat_gateway_instance.id
  depends_on = [
    aws_internet_gateway.ig
  ]
  tags = {
    Name = "nat-gateway-eip"
  }
}

# Elastic-IP (eip) for Bastion Host
resource "aws_eip" "bastion_host_eip" {
  vpc                  = true
  network_border_group = var.network_border_group
  instance             = aws_instance.bastion_host.id
  depends_on = [
    aws_internet_gateway.ig
  ]
  tags = {
    Name = "bastion-host-eip"
  }
}

# Elastic-IP (eip) for Load Balancer Server
resource "aws_eip" "app_load_balancer_eip" {
  vpc                  = true
  network_border_group = var.network_border_group
  instance             = aws_instance.app_load_balancer.id
  depends_on = [
    aws_internet_gateway.ig
  ]
  tags = {
    Name = "app-load-balancer-eip"
  }
}

resource "aws_eip" "web_load_balancer_eip" {
  vpc                  = true
  network_border_group = var.network_border_group
  instance             = aws_instance.web_load_balancer.id
  depends_on = [
    aws_internet_gateway.ig
  ]
  tags = {
    Name = "web-load-balancer-eip"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  count             = length(var.public_subnets_cidr)
  cidr_block        = element(var.public_subnets_cidr, count.index)
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.PROJECT_NAME}-public-subnet-${count.index + 1}"
  }
}


# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.PROJECT_NAME}-private-subnet-${count.index + 1}"
  }
}


# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = "${var.PROJECT_NAME}-private-route-table"
    Environment = "${var.PROJECT_NAME}"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = "${var.PROJECT_NAME}-public-route-table"
    Environment = "${var.PROJECT_NAME}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_gateway_instance.primary_network_interface_id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
