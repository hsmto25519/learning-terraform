resource "aws_security_group" "this" {
  name        = var.name
  description = "managed by Terraform"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "rule" {
  for_each = { for rule in var.rules : "${rule.type}-${rule.from_port}-${rule.to_port}-${rule.protocol}-${rule.cidr_blocks[0]}" => rule }

  description       = "terraform examples"
  security_group_id = aws_security_group.this.id
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}
