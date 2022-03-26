
output "web_server_id" {
  value = aws_instance.my_aws_instance_public_b.id
}

output "elasticIp" {
  value = aws_eip.static_ip.public_ip
}

