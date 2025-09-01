

provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "EC2_instance" {
  ami                    = "ami-0360c520857e3138f"
  instance_type          = "t2.micro"
  key_name               = "vpc-key"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
  tags = {
    Name="Jenkins"
  }
}
# 1. Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

# 2. Create a Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my-subnet"
  }
}
# 3. Create a Security Group
resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.my_vpc.id

  # Inbound rules
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg"
  }
}

output "instance_public_ip" {
  description = "The public IP Addressof the ec2 instance"
  value       = aws_instance.EC2_instance.public_ip
}
output "instance_private_ip" {
  description = "The private IP Addressof the ec2 instance"
  value       = aws_instance.EC2_instance.private_ip
}
#tf file