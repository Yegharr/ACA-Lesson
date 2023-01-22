provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "myapp-vpc"
  }
}

resource "aws_subnet" "myapp-subnet1" {
  vpc_id = aws_vpc.myapp-vpc.id 
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "myapp-subnet1"
  }
}

resource "aws_subnet" "myapp-subnet2" {
  vpc_id = aws_vpc.myapp-vpc.id 
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "myapp-subnet2"
  }
}



resource "aws_internet_gateway" "mayapp-igw" {
 vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "myapp-igw"
  }
}

resource "aws_route_table" "myapp-route-tables" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.mayapp-igw.id
}
  tags = {
    Name = "mayapp-rtb"
  }
}

  resource "aws_route_table_association" "a-rtb-subnet1" {
  subnet_id = aws_subnet.myapp-subnet1.id
  route_table_id = aws_route_table.myapp-route-tables.id
}

resource "aws_route_table_association" "a-rtb-subnet2" {
  subnet_id = aws_subnet.myapp-subnet2.id
  route_table_id = aws_route_table.myapp-route-tables.id
}


resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "myapp-template"
  image_id      = "ami-0ceecbb0f30a902a6"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.myapp-sg.id]
  user_data = file("user-data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "myapp-asg" {
  name                 = "myapp-asg"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = 2
  max_size             = 3
  vpc_zone_identifier  = [aws_subnet.myapp-subnet1.id, aws_subnet.myapp-subnet2.id]
  #target_group_arns = [aws_alb_target_group.myapp-tg.arn]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "myapp-sg" {
  name        = "myapp-sg"
  description = "security_group"
  vpc_id      = aws_vpc.myapp-vpc.id
  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
    Name    = "myapp-sg"
  }
}

resource "aws_lb_target_group" "myapp-tg" {
  name     = "myapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myapp-vpc.id
  target_type  = "instance"
}

 resource "aws_lb" "myapp-lb" {
  name = "myapp-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.myapp-sg.id]
  subnets = [aws_subnet.myapp-subnet1.id, aws_subnet.myapp-subnet2.id]
  }

  resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.myapp-lb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myapp-tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_myapp" {
   autoscaling_group_name = aws_autoscaling_group.myapp-asg.id
   lb_target_group_arn = aws_lb_target_group.myapp-tg.arn
}