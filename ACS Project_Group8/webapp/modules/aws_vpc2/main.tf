# VPC module - main.tf

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a new VPC 
resource "aws_vpc" "smain" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-vpc"
    }
  )
}


# Add provisioning of the public subnetin the default VPC
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.smain.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  #availability_zone = "us-east-1b"
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-public-subnet-${count.index}"
    }
  )
}

# Add provisioning of the private subnets in the custom VPC
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.smain.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  #availability_zone = "us-east-1b"
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-private-subnet-${count.index}"
      Tier = "Private"
    }
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.smain.id

  tags = merge(var.default_tags,
    {
      "Name" = "${var.prefix}-igw"
    }
  )
}

# Route table to route add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.smain.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-route-public-route_table"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

#Create NAT GW

# Create elastic IP for NAT GW
resource "aws_eip" "nat-eip" {
  vpc   = true
  tags = {
    Name = "${var.prefix}-natgw"
  }

}
# NAT gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.prefix}-natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Route table to route add default gateway pointing to NAT Gateway (NATGW)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.smain.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "${var.prefix}-route-private-route_table",
    Tier = "Private"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet[*].id)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

