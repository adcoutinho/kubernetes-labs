resource "aws_security_group" "this" {
  count = local.create_security_group ? 1 : 0

  name        = "${local.cluster_name}-sg"
  name_prefix = "${local.cluster_name}-"
  description = var.security_group_description
  vpc_id      = local.vpc_id

  tags = merge(
    local.tags,
    { "Name" = local.security_group_name }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "this" {
  for_each = { for k, v in local.security_group_rules : k => v }

  # Required
  security_group_id = aws_security_group.this[0].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description      = try(each.value.description, null)
  cidr_blocks      = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids  = try(each.value.prefix_list_ids, [])
  self             = try(each.value.self, null)
  source_security_group_id = try(
    each.value.source_security_group_id,
    try(each.value.source_cluster_security_group, false) ? var.cluster_security_group_id : null
  )
}
