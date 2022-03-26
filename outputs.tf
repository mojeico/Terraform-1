/*

output "web_server_id" {
  value = aws_instance.my_aws_instance_public_b.id
}

output "elasticIp" {
  value = aws_eip.static_ip.public_ip
}

*/


output "web_load_balancer_url" {
  value = aws_elb.load_balancer.dns_name
}