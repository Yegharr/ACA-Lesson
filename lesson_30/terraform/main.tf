provider "aws" {
    region = var.region
}

variable  vpc_cidr_block {}
variable  subnet_cidr_block1 {}
variable  subnet_cidr_block2 {}
variable  availability_zone {}
variable  prefix {}
variable  instance_type {}
variable  region {}
variable  public_ip {}



resource "aws_vpc" "app-vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Name = "${var.prefix}-vpc"
  }
 }

resource "aws_subnet" "subnet-one" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = var.subnet_cidr_block1
    availability_zone = var.availability_zone
    map_public_ip_on_launch = var.public_ip

    tags = {
        Name = "subnet-one"
  }
}

resource "aws_subnet" "subnet-two" {
   vpc_id = aws_vpc.app-vpc.id
   cidr_block = var.subnet_cidr_block2
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = var.public_ip

    tags = {
        Name = "subnet-two"
  }
}

resource "aws_internet_gateway" "app-ig"{
    vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "${var.prefix}-ig"
  }
}

resource "aws_route_table" "app-rt"{
    vpc_id = aws_vpc.app-vpc.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-ig.id
    }

    tags = {
    Name = "${var.prefix}-rt"
    }
}

resource "aws_route_table_association" "ass-rt1" {
    subnet_id = aws_subnet.subnet-one.id
    route_table_id = aws_route_table.app-rt.id
}

resource "aws_route_table_association" "ass-rt2" {
    subnet_id = aws_subnet.subnet-two.id
    route_table_id = aws_route_table.app-rt.id
}

resource "aws_security_group" "app-sg" {
    name = "${var.prefix}-sg"
    vpc_id = aws_vpc.app-vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "22", "8080"  ]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.prefix}-sg"
  }
}

data "aws_ami" "latest-ubuntu-image" {
     most_recent = true
     owners =["099720109477"]
     filter {
       name = "name"
       values =  ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
     }
}

 resource "aws_instance" "EC2-machine" {
   count = 2
   ami = data.aws_ami.latest-ubuntu-image.id
   instance_type = var.instance_type

   subnet_id = aws_subnet.subnet-one.id
   vpc_security_group_ids = [aws_security_group.app-sg.id]
   availability_zone = var.availability_zone
   associate_public_ip_address = var.public_ip
   key_name = "EC2_key-pair"

   tags = {
     Name    = "EC2-machine-${count.index + 1}"
   }
 }


 output "instance_public_ip" {
   description = "Public IP address of the EC2 instance"
   value = aws_instance.EC2-machine.*.public_ip
 }
