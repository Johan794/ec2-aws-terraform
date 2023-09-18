#Define the provider and region
provider "aws" {
  region = "${var.aws_region}"
}

#Create the vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "${var.vpc_name}"
  }
}
#Create the subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.vpc_name}"
  }
}

#Create the network interface
resource "aws_network_interface" "aws_nf" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = "${var.private_ips}"
  security_groups = [aws_security_group.security_group.id] #Assign the security group
  tags = {
    Name = "primary_network_interface"
  }
}

#Define the security group
resource "aws_security_group" "security_group" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "my-security-group"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false

  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "my-security-group"
  }
}

#Create the internet gateway
resource "aws_internet_gateway" "aws_Ig" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-ig"
  }
}

#Create the route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-route-table"
  }
}

#Create the route table association
resource "aws_route_table_association" "my_subnet_vpc_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.route_table.id
}

#Create the route
resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_Ig.id
}

#Define the AMI for the instance, in this case Ubuntu 20.04 in order to get the most recent AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id #Get the AMI ID
  instance_type = "t2.micro" #Set the instance type
  #Assign the network interface
  network_interface {
    network_interface_id = aws_network_interface.aws_nf.id
    device_index         = 0
  }
  #Tags
  tags = {
    Name = "ec2-VM"
  }
}
