provider "aws" {
    #access_key = "${var.AWS_ACCESS_KEY}"
  #secret_key = "${var.AWS_SECRET_KEY}"
  region     = "${var.aws_region}"
}
                  #AWS VPC
resource "aws_vpc" "jaya" {
  cidr_block       = "${var.vpc_cidr}"
  tags = {
    Name = "${var.vpc_name}"
  }
}
#AWS IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.jaya.id}"

  tags = {
    Name = "${var.IGW_name}"
  }
}
# AWS SUBNETS
resource "aws_subnet" "subnet-1" {
  vpc_id     = "${aws_vpc.jaya.id}"
  cidr_block = "${var.subnet1_cidr}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.subnet1_name}"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = "${aws_vpc.jaya.id}"
  cidr_block = "${var.subnet2_cidr}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.subnet2_name}"
  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id     = "${aws_vpc.jaya.id}"
  cidr_block = "${var.subnet3_cidr}"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.subnet3_name}"
  }
}

resource "aws_subnet" "subnet-4" {
  vpc_id     = "${aws_vpc.jaya.id}"
  cidr_block = "${var.subnet4_cidr}"
  availability_zone = "us-east-1d"

  tags = {
    Name = "${var.subnet4_name}"
  }
}


#AWS ROUTE TABLE
resource "aws_route_table" "example" {
  vpc_id = "${aws_vpc.jaya.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

#   route {
#     ipv6_cidr_block        = "::/0"
#     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
#   }

  tags = {
    Name ="${var.Route_table}"
  }
}


#AWS ROUTE TABLE ASSOCIATION 
resource "aws_route_table_association" "terraform-public1" {
    subnet_id = "${aws_subnet.subnet-1.id}"
    route_table_id = "${aws_route_table.example.id}"
}

resource "aws_route_table_association" "terraform-public2" {
    subnet_id = "${aws_subnet.subnet-2.id}"
    route_table_id = "${aws_route_table.example.id}"
}

resource "aws_route_table_association" "terraform-public3" {
    subnet_id = "${aws_subnet.subnet-3.id}"
    route_table_id = "${aws_route_table.example.id}"
}

resource "aws_route_table_association" "terraform-public4" {
    subnet_id = "${aws_subnet.subnet-4.id}"
    route_table_id = "${aws_route_table.example.id}"
}

#AWS SECURITY GROUP
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.jaya.id}"

  ingress {
    description      = "allow all ports"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

}