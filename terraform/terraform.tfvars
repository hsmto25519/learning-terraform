key_name      = "my-ssh-key"
instance_type = "t3.micro"

cidr_block = {
  base = "10.100.0.0/16"
  subnet = {
    public = {
      ec2_01 = "10.100.16.0/20"
    }
    private = {
      lb_01  = "10.100.0.0/24"
      ec2_02 = "10.100.32.0/20"
      rds_01 = "10.100.240.0/24"
    }
  }
}
