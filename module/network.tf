resource "aws_vpc" "eks-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "hiive-vpc"
  }
}

resource "aws_subnet" "subnet-zone-a" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ca-central-1a" # Specify the desired AZ

  tags = {
    Name = "hiive-vpc-subnet-zone-a"
  }
}
resource "aws_subnet" "subnet-zone-b" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ca-central-1b" # Specify the desired AZ

  tags = {
    Name = "hiive-vpc-subnet-zone-b"
  }
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.eks-vpc.id

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0" # narrow down access as per needed
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}