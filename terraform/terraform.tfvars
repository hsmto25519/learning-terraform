tags = {
  Environment = "dev"
  Usage       = "learning-terraform"
}

vpc_name = "my-vpc"
cidr_block = {
  base = "10.100.0.0/16"
  subnet = {
    public = {
      lb_01  = { cidr = "10.100.0.0/24", az = "ap-northeast-1a" }
      lb_02  = { cidr = "10.100.1.0/24", az = "ap-northeast-1c" }
      ec2_01 = { cidr = "10.100.16.0/20", az = "ap-northeast-1a" }
    }
    private = {
      ec2_02 = { cidr = "10.100.32.0/20", az = "ap-northeast-1c" }
      rds_01 = { cidr = "10.100.240.0/24", az = "ap-northeast-1a" }
    }
  }
}

sg = {
  "my-alb-sg" = {
    rules = [
      { type = "ingress", from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { type = "egress", from_port = 0, to_port = 0, protocol = "all", cidr_blocks = ["0.0.0.0/0"] },
    ]
  }
  "my-ec2-sg" = {
    rules = [
      { type = "ingress", from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { type = "ingress", from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { type = "egress", from_port = 0, to_port = 0, protocol = "all", cidr_blocks = ["0.0.0.0/0"] },
    ]
  }
}

igw_name = "my-igw"
rt_name  = "my-rt"

alb_name          = "my-alb"
alb_tg_name       = "ec2-tg"
alb_listener_name = "ec2-listener"

ec2_name      = "my-ec2"
key_name      = "my-ssh-key"
instance_type = "t3.micro"
