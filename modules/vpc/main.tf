# ==============================================================
# VPC
# ==============================================================

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr # 10.0.0.0/16
  instance_tenancy = "default"
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostname

  tags = merge(
    {
        Name = "${terraform.workspace}-vpc"
    },
    var.tags
  )
}

# ==============================================================
# PUBLIC SUBNETS -> [ 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 ]
# ==============================================================

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    {
        Name = "${terraform.workspace}-public-${count.index + 1}"
    },
    var.tags
  )
}

# ==============================================================
# APPLICATION PRIVATE SUBNETS -> [ 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24 ]
# ==============================================================

resource "aws_subnet" "app_private_subnets" {
  count = length(var.app_private_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.app_private_subnets[count.index]

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = false

  tags = merge(
    {
        Name = "${terraform.workspace}-app-private-${count.index + 1}"
    },
    var.tags
  )
}

# ==============================================================
# DATA PRIVATE SUBNETS -> [ 10.0.21.0/24, 10.0.22.0/24, 10.0.23.0/24 ]
# ==============================================================

resource "aws_subnet" "data_private_subnets" {
  count = length(var.data_private_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.data_private_subnets[count.index]

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = false

  tags = merge(
    {
        Name = "${terraform.workspace}-data-private-${count.index + 1}"
    },
    var.tags
  )
}

# ==============================================================
# PUBLIC ROUTE TABLES
# ==============================================================

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  depends_on = [ aws_vpc.main ]

  tags = merge(
    {
        Name = "${terraform.workspace}-public-rt"
    },
    var.tags
  )
}

# ==============================================================
# APPLICATION PRIVATE ROUTE TABLES
# ==============================================================

resource "aws_route_table" "app_private_rt" {
  vpc_id = aws_vpc.main.id
  depends_on = [ aws_vpc.main ]

  tags = merge(
    {
        Name = "${terraform.workspace}-app-private-rt"
    },
    var.tags
  )
}

# ==============================================================
# DATA PRIVATE ROUTE TABLES
# ==============================================================

resource "aws_route_table" "data_private_rt" {
  vpc_id = aws_vpc.main.id
  depends_on = [ aws_vpc.main ]

  tags = merge(
    {
        Name = "${terraform.workspace}-data-private-rt"
    },
    var.tags
  )
}

# ==============================================================
# PUBLIC SUBNETS ASSOCIATION
# ==============================================================

resource "aws_route_table_association" "public_subnets_association" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ==============================================================
# ASSOCIATE APP PRIVATE SUBNETS
# ==============================================================

resource "aws_route_table_association" "app_private_subnets_association" {
  count = length(var.app_private_subnets)
  subnet_id      = aws_subnet.app_private_subnets[count.index].id
  route_table_id = aws_route_table.app_private_rt.id
}

# ==============================================================
# ASSOCIATE DATA PRIVATE SUBNETS
# ==============================================================

resource "aws_route_table_association" "data_private_subnets_association" {
  count = length(var.data_private_subnets)
  subnet_id      = aws_subnet.data_private_subnets[count.index].id
  route_table_id = aws_route_table.data_private_rt.id
}

# ==============================================================
# INTERNET GATEWAY
# ==============================================================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
        Name = "${terraform.workspace}-igw"
    },
    var.tags
  )
}

# ==============================================================
# NAT EIP
# ==============================================================

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = merge(
    {
        Name = "${terraform.workspace}-nat-eip"
    },
    var.tags
  )
}

# ==============================================================
# NAT
# ==============================================================

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = merge(
    {
        Name = "${terraform.workspace}-nat"
    },
    var.tags
  )
}

# ==============================================================
# PUBLIC ROUTE -> INTERNET GATEWAY
# ==============================================================

resource "aws_route" "internet" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = var.anywhere
  gateway_id = aws_internet_gateway.igw.id

  depends_on = [ aws_route_table.public_rt, aws_internet_gateway.igw ]
}

# ==============================================================
# APP PRIVATE ROUTES -> NAT GATEWAYS
# ==============================================================

resource "aws_route" "app_private_nat" {
  route_table_id            = aws_route_table.app_private_rt.id
  destination_cidr_block    = var.anywhere
  nat_gateway_id            = aws_nat_gateway.nat.id
}