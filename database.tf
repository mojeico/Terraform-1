resource "aws_db_instance" "mysql" {

  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.db_t_3_micro
  name                 = "mydb"
  username             = "administrator"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
  identifier           = "devterraformrds"

}

resource "aws_db_subnet_group" "rds_subnet_group" {
  subnet_ids = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  name       = "dev_rds_subnet_group"

}