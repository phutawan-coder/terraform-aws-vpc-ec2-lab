output "ec2_public_ip" {
  description = "Public IP"
  value = aws_instance.app.public_ip
}

output "ec2_private_ip" {
  description = "Private IP"
  value = aws_instance.db.private_ip
}
