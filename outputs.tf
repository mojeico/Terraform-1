
output "web_server_id" {
  value = aws_instance.my_aws_instance_public_b.id
}

output "elasticIp" {
  value = aws_eip.static_ip.public_ip
}

output "zones_output_data" {
  value = data.aws_availability_zones.aws_zone.names
}

output "caller_id_output_data" {
  value = data.aws_caller_identity.caller_id.account_id
}
