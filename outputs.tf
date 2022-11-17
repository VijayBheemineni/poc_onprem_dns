output "bindserver_private_ip" {
  value = aws_instance.bind_dns.private_ip
}

output "bindserver_public_ip" {
  value = aws_instance.bind_dns.public_ip
}