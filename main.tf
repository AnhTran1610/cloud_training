terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  #   profile = "cloud_user"
  region = "us-east-1"
}

data "aws_ami" "amzn2_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amzn2_ami.id
  instance_type = "t2.micro"
  tags = {
    Owner = "huyy"
    Name  = "huyy_server"
  }
}

resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name  = "huyy_vpc"
    Owner = "huyy"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name  = "huyy_igw"
    Owner = "huyy"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.0.0.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name  = "huyy_rtb"
    Owner = "huyy"
  }
}

# Declare the data source
data "aws_availability_zones" "available_az" {
  state = "available"
}

# e.g. Create subnets in the first two available availability zones

resource "aws_subnet" "primary_subnet" {
  availability_zone = data.aws_availability_zones.available_az.names[0]
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.0.0/24"

  tags = {
    Name  = "huyy_primary_subnet"
    Owner = "huyy"
  }
}

resource "aws_subnet" "secondary_subnet" {
  availability_zone = data.aws_availability_zones.available_az.names[1]
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name  = "huyy_secondary_subnet"
    Owner = "huyy"
  }
}