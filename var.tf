variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_a_cidr_block" {
  default = "10.0.1.0/24"
}


variable "public_subnet_b_cidr_block" {
  default = "10.0.2.0/24"
}

variable "route_table_internet" {
  default = "0.0.0.0/0"
}

variable "internet" {
  default = "0.0.0.0/0"
}

variable "allow_ports" {
  default = [80, 443, 22]
  type    = list
}

variable "port_80" {
  default = 80
}

variable "port_443" {
  default = 443
}

variable "port_22" {
  default = 22
}

variable "t_2_micro_type" {
  default = "t2.micro"
}


variable "common_tag" {
  default = {

    Owner = "Gleb Mojeico"
    Env = "DEV"
    Version = "v1.1"
  }
}