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
  tags       = merge({ Name = var.key_name }, var.tags)
}

############################################################
### Virtual Private Cloud
############################################################
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block.base
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge({ Name = var.vpc_name }, var.tags)
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge({ Name = var.igw_name }, var.tags)
}

resource "aws_subnet" "subnets" {
  for_each = local.subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = merge({ Name = each.key }, var.tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge({ Name = var.rt_name }, var.tags)
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
module "sgs" {
  source   = "./modules/security_group"
  for_each = var.sg

  name   = "${each.key}-${random_string.this.result}"
  vpc_id = aws_vpc.this.id
  rules  = each.value.rules

  tags = merge({ Name = each.key }, var.tags)
}

############################################################
### ALB
############################################################
module "alb" {
  source = "./modules/application_loadbalancer"

  name           = var.alb_name
  tg_name        = var.alb_tg_name
  listener_name  = var.alb_listener_name
  target_id      = aws_instance.this.id
  vpc_id         = aws_vpc.this.id
  subnet_ids     = local.lb_subnet_ids
  security_group = module.sgs["my-alb-sg"].id
  tags           = var.tags
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

  subnet_id                   = aws_subnet.subnets["ec2_01"].id
  vpc_security_group_ids      = [module.sgs["my-ec2-sg"].id]
  associate_public_ip_address = true
  tags                        = merge({ Name = var.ec2_name }, var.tags)
}
