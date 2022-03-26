data "aws_availability_zones" "aws_zone" {}

data "aws_caller_identity" "caller_id" {}

data "aws_region" "region" {}

data "aws_vpcs" "my_vpc_list" {}

/*data "aws_vpc" "my_own_vpc" {
  tags = {
    Name:"Terraform VPC"
  }
}*/

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


output "zones_output_data" {
  value = data.aws_availability_zones.aws_zone.names
}

output "caller_id_output_data" {
  value = data.aws_caller_identity.caller_id.account_id
}


output "region_output_data" {
  value = data.aws_region.region.name
}


output "vpc_list_output_data" {
  value = data.aws_vpcs.my_vpc_list.ids
}
/*
output "vpc_output_data" {
  value = data.aws_vpc.my_own_vpc.id
}*/


