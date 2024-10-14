resource "aws_security_group" "es" {
  name        = "${var.vpc_id}-elasticsearch-${var.cluster_name}"
  description = "Managed by Terraform"
  vpc_id      = data.aws_vpc.selected.id
}

resource "aws_security_group_rule" "es_inbound_cidrs" {
  for_each          = { for cidr in var.allow_cidrs : cidr.name => cidr }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = try(each.value.protocol, "tcp")
  cidr_blocks       = each.value.cidr
  security_group_id = aws_security_group.es.id
  description       = try(each.value.description, "From CIDR ${each.value.cidr}")
}

resource "aws_security_group_rule" "es_inbound_from_sg" {
  for_each                 = { for security_group_id in var.allow_security_group_ids : security_group_id.name => security_group_id }
  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = "tcp"
  source_security_group_id = each.value.security_group_id
  security_group_id        = aws_security_group.es.id
  description              = try(each.value.description, "From ${each.value.security_group_id}")
}

resource "aws_security_group_rule" "es_egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.es.id
  cidr_blocks       = ["0.0.0.0/0"]
}
