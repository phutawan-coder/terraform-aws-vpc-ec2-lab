output "ec2_public_IP" {
  description = "IP"
  value = aws_instance.this.public_ip
}
