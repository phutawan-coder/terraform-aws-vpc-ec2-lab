resource "aws_instance" "this" {
  ami                    = "ami-0b3c832b6b7289e44"
  instance_type          = "t3.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

  associate_public_ip_address = true

  key_name = var.key_name   

  tags = {
    Name = "ec2-app-lab2"
  }
}
