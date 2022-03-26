resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.common_tag, {
    Name : "${var.common_tag["Env"]} - Terraform VPC"
  })

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(var.common_tag, {
    Name : "${var.common_tag["Env"]} - Terraform internet gateway"
  })

}


resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_a_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.aws_zone.names[0]


  tags = merge(var.common_tag, {
    Name : "${var.common_tag["Env"]} - Terraform public subnet 1a"
  })

}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_b_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.aws_zone.names[1]


  tags = merge(var.common_tag, {
    Name : "${var.common_tag["Env"]} - Terraform public subnet 1b"
  })
}

resource "aws_route_table" "rtb_public_a" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.route_table_internet
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "rta_subnet_public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.rtb_public_a.id
}


resource "aws_route_table" "rtb_public_b" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.route_table_internet
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "rta_subnet_public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.rtb_public_b.id
}


resource "aws_elb" "load_balancer" {
  //availability_zones = [data.aws_availability_zones.aws_zone.names[0], data.aws_availability_zones.aws_zone.names[1]]
  security_groups = [aws_security_group.my_security_group.id]
  subnets         = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]

  listener {
    instance_port     = var.port_80
    instance_protocol = "http"
    lb_port           = var.port_80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    interval            = 10
    target              = "HTTP:80/"
    timeout             = 3
    unhealthy_threshold = 2
  }


  tags = merge(var.common_tag, {
    Name : "${var.common_tag["Env"]} - Terraform LB"
  })


}
