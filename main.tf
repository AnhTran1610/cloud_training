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

data "aws_availability_zones" "available_az" {
  state = "available"
}

resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name  = "ahta_vpc"
    Owner = "ahta"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name  = "ahta_igw"
    Owner = "ahta"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.subnets_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.subnets_cidr, count.index)
  availability_zone       = data.aws_availability_zones.available_az.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name  = "ahta_public_subnet_${count.index + 1}"
    Owner = "ahta"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name  = "ahta_public_routing_table"
    Owner = "ahta"
  }
}

resource "aws_route_table_association" "selected" {
  count          = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_instance" "webserver_instances" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amzn2_ami.id
  instance_type          = var.instance_type
  subnet_id              = element(aws_subnet.public.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  key_name               = var.ssh_key_pair
  user_data              = file("httpd_install.sh")

  tags = {
    Name  = "ahta_webserver_${count.index + 1}"
    Owner = "ahta"
  }

  connection {
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("theanh.pem")
    agent       = true
  }

  provisioner "file" {
    source      = "sourceweb"
    destination = "/home/ec2-user"
  }
    
}


#############################################
# OLD TERRAFORM CODE WITHOUT LOOPING METHOD #
#############################################
# resource "aws_subnet" "primary_subnet" {
#   availability_zone       = data.aws_availability_zones.available_az.names[0]
#   map_public_ip_on_launch = true

#   vpc_id     = aws_vpc.main_vpc.id
#   cidr_block = "10.0.0.0/24"

#   tags = {
#     Name  = "huyy_primary_subnet"
#     Owner = "huyy"
#   }
# }

# resource "aws_subnet" "secondary_subnet" {
#   availability_zone       = data.aws_availability_zones.available_az.names[1]
#   map_public_ip_on_launch = true

#   vpc_id     = aws_vpc.main_vpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name  = "huyy_secondary_subnet"
#     Owner = "huyy"
#   }
# }

# resource "aws_route_table" "rtb" {
#   vpc_id = aws_vpc.main_vpc.id

#   route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   route {
#     cidr_block = "10.0.0.0/24"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name  = "huyy_rtb"
#     Owner = "huyy"
#   }
# }
# resource "aws_instance" "web_server" {
#   ami           = data.aws_ami.amzn2_ami.id
#   instance_type = "t2.micro"
#   tags = {
#     Owner = "huyy"
#     Name  = "huyy_server"
#   }
# }
