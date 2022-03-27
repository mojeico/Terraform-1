resource "aws_launch_configuration" "web_server" {
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.t_2_micro_type
  name_prefix     = "${var.common_tag["Env"]} - Terraform launch conf - "
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
  min_size             = 2
  launch_configuration = aws_launch_configuration.web_server.name
  min_elb_capacity     = 2
  //name                 = "Terraform autoscaling group"
  name_prefix          = "Terraform-autoscaling-group-"
  vpc_zone_identifier  = [aws_subnet.public_subnet_b.id, aws_subnet.public_subnet_a.id]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.load_balancer.name]

  dynamic "tag" {


    for_each = merge(var.common_tag, {
      Name = " ${var.common_tag["Env"]} - Terraform group"
    })
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

  count                  = var.env == "dev"?1 : 0
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.t_2_micro_type
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

  tags = merge(var.common_tag, {
    Name = " ${var.common_tag["Env"]} - Public terraform web instance "
  })

}


resource "aws_security_group" "my_security_group" {
  description = "Security group for aws  by id"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      protocol    = "tcp"
      to_port     = ingress.value
      cidr_blocks = [var.internet]
    }
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.internet]
  }


  tags = merge(var.common_tag, {
    Name : "${var.common_tag["Env"]} - Terraform dynamic sec group"
  })

}


resource "aws_instance" "foo" {
  ami           = "ami-0dcc0ebde7b2e00db"
  instance_type = "t2.micro"
  provider      = aws.EU
}



