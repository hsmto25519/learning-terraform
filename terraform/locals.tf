locals {
  subnets = merge(
    var.cidr_block.subnet.public,
    var.cidr_block.subnet.private
  )

  # use an if statement to specify only "lb" subnets
  lb_subnet_ids = [for k, v in aws_subnet.subnets : v.id if startswith(k, "lb")]
}
