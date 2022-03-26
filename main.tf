# terraform init - download providers
# terraform plan - show what terraform will create
# terraform apply - create all resource
# terraform validate - make sure your configuration is syntactically valid
# terraform output - print output
# terraform show - print all resources with info
# terraform destroy - destroy all resource


provider "aws" {
  access_key = "----"
  secret_key = "----"
  region     = "us-east-1"
}


resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name : "Terraform VPC"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name : "Terraform internet gateway"
  }
}


resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name : "Terraform public subnet 1a"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.rtb_public.id
}


resource "aws_eip" "static_ip" {
  instance = aws_instance.my_aws_instance_public_b.id

  tags = {
    Name : "Terraform ip"
  }


}


resource "aws_instance" "database-public-server" {

  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  lifecycle {
    #prevent_destroy = true
  }

  tags = {
    Name = "Public terraform database instance"
  }
}


resource "aws_instance" "my_aws_instance_public_b" {

  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = templatefile("./start_up.sh.tftpl", {
    test_val   = "The page was created by template file"
    name_val   = "Jon"
    names_list = ["Donald", "Petya", "Ion"]
  } )

  depends_on = [aws_instance.database-public-server]

  lifecycle {
    //prevent_destroy = true
    ignore_changes = ["ami", "instance_type"]
    #create_before_destroy = true
  }

  tags = {
    Name = "Public terraform web instance"
  }
}

resource "aws_security_group" "my_security_group" {

  description = "Security group for aws  by id"
  vpc_id      = aws_vpc.my_vpc.id


  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      protocol    = "tcp"
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name : "Terraform dynamic sec group"
  }

}

