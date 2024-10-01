# for education purposes
resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
}

############################################################
### an SSH key for the EC2 instance
############################################################
resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "this" {
  key_name   = "${var.key_name}-${random_string.this.result}"
  public_key = tls_private_key.this.public_key_openssh
}

############################################################
### Security Groups
############################################################
resource "aws_security_group" "sg_ec2" {
  name        = "my-sg-${random_string.this.result}"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################################
### EC2
############################################################
# Use the data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.this.key_name

  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  associate_public_ip_address = true
}
