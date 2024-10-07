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
### Virtual Private Cloud
############################################################
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block.base

  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "subnets" {
  for_each = local.subnets

  vpc_id     = aws_vpc.this.id
  cidr_block = each.value
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  for_each = var.cidr_block.subnet.public

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public.id
}

# all private subnets associate with the main route table in the VPC.
resource "aws_route_table_association" "private" {
  for_each = var.cidr_block.subnet.private

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_vpc.this.main_route_table_id
}

############################################################
### Security Group
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
