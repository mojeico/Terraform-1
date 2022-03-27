# terraform init - download providers
# terraform plan - show what terraform will create
# terraform apply - create all resource
# terraform validate - make sure your configuration is syntactically valid
# terraform output - print output
# terraform show - print all resources with info
# terraform destroy - destroy all resource


provider "aws" {
  access_key = "-----"
  secret_key = "-----"
  region     = var.usa-region
}

provider "aws" {
  access_key = "-----"
  secret_key = "-----"
  region     = var.eu-region
  alias      = "EU"
}


resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!%$#($@"
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  type        = "SecureString"
  value       = random_string.rds_password.result
  description = "Master password for rds"

}


data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}


#var.env == "prod" ? "t.large":"t.smal"