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
  region     = var.region
}


