resource "aws_launch_configuration" "web_server" {
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t2.micro"
  // name            = "Terraform LC"
  name_prefix     = "Terraform-LC-"
  security_groups = [aws_security_group.my_security_group.id]

  user_data = templatefile("./start_up.sh.tftpl", {
    test_val   = "The page was created by template file"
    name_val   = "Jon"
    names_list = ["Donald", "Petya", "Ion"]
  } )

  #depends_on = [aws_instance.database-public-server]

    lifecycle {
      create_before_destroy = true
    }
}


resource "aws_autoscaling_group" "aws_auto_group" {
  max_size             = 10
  min_size             = 1
  launch_configuration = aws_launch_configuration.web_server.name
  min_elb_capacity     = 2
  //name                 = "Terraform autoscaling group"
  name_prefix          = "Terraform-autoscaling-group-"
  vpc_zone_identifier  = [aws_subnet.public_subnet_b.id, aws_subnet.public_subnet_a.id]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.load_balancer.name]

  dynamic "tag" {
    for_each = {
      Name  = "Terraform group"
      Owner = "Gleb Mojeico"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_instance" "my_aws_instance_public_b" {

  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = templatefile("./start_up.sh.tftpl", {
    test_val   = "The page was created by template file"
    name_val   = "Jon"
    names_list = ["Donald", "Petya", "Ion"]
  } )

  #depends_on = [aws_instance.database-public-server]

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







