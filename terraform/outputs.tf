output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

output "private_key_content" {
  value     = tls_private_key.this.private_key_openssh
  sensitive = true
}
