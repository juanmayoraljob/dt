# Defino una VPC
resource "aws_vpc" "srv_vpc" {
    cidr_block = "172.0.0.0/22"

    tags = {
      Name = "srv_vpc"
    }
}

# Defino un igw.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.srv_vpc.id
  tags = {
    Name = "igw"
  }
}

# Defino las subnets públicas.
resource "aws_subnet" "pub_subnet_sa1a" {
  vpc_id            = aws_vpc.srv_vpc.id
  cidr_block        = "172.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "sa-east-1a"

  tags = {
    Name = "pub_subnet_sa1a"
  }
}

resource "aws_subnet" "pub_subnet_sa1c" {
  vpc_id            = aws_vpc.srv_vpc.id
  cidr_block        = "172.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "sa-east-1c"

  tags = {
    Name = "pub_subnet_sa1c"
  }
}

# Defino la subnet privada.
resource "aws_subnet" "priv_subnet_ws" {
  vpc_id            = aws_vpc.srv_vpc.id
  cidr_block        = "172.0.3.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "priv_subnet_ws"
  }
}


# Defino la ip estatica. 
resource "aws_eip" "srv_eip" {
  vpc = true
}

# Defino un nat gateway para los webservers y le asigno una ip estatica.
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.srv_eip.id
  subnet_id = aws_subnet.pub_subnet_sa1a.id
  tags = {
    "Name" = "nat_gateway"
  }
}

# Tabla de ruteo pub
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.srv_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub_rt"
  }
}

# Tabla de ruteo priv
resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.srv_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "priv_rt"
  }
}

# Asociación de la subnet priv a la tabla de ruteo.
resource "aws_route_table_association" "private_rt_as" {
  subnet_id = aws_subnet.priv_subnet_ws.id
  route_table_id = aws_route_table.priv_rt.id
}

# Asociación de las 2 subnets priv a la tabla de ruteo.
resource "aws_route_table_association" "public_rt_sa1a_as" {
  subnet_id      = aws_subnet.pub_subnet_sa1a.id
  route_table_id = aws_route_table.pub_rt.id
}
resource "aws_route_table_association" "public_rt_sa1c_as" {
  subnet_id      = aws_subnet.pub_subnet_sa1c.id
  route_table_id = aws_route_table.pub_rt.id
}