# Public EC2 Instance
resource "aws_instance" "public_instance" {
  ami               = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  tags = local.tags
}

# Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami               = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.id]

  tags = local.tags
}

