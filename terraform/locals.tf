locals {
  subnets = merge(
    var.cidr_block.subnet.public,
    var.cidr_block.subnet.private
  )
}
