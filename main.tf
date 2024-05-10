
locals {
  name-prefix = lower("${var.org}-${var.proj}-${var.env}") // prefix for naming resources
}

data "aws_region" "current" {}

resource "aws_ec2_managed_prefix_list" "pl" {
  for_each       = var.pl
  name           = "${local.name-prefix}-${each.key}-pl"
  address_family = each.value.address_family
  max_entries    = each.value.max_entries
  dynamic "entry" {
    for_each = each.value.entries
    content {
      cidr        = entry.value
      description = entry.key
    }
  }
  tags = merge(each.value.tags, {
    Name = "${local.name-prefix}-${each.key}"
  })
}


locals {
  pl_share = { for k, v in var.pl : k => v if length(v.pl_share_principal_list) != 0 }
}
resource "aws_ram_resource_share" "pl" {
  for_each                  = local.pl_share
  name                      = aws_ec2_managed_prefix_list.pl[each.key].id
  allow_external_principals = false
}


resource "aws_ram_resource_association" "pl" {
  for_each           = local.pl_share
  resource_arn       = aws_ec2_managed_prefix_list.pl[each.key].arn
  resource_share_arn = aws_ram_resource_share.pl[each.key].arn
}

module "pl_share" {
  source    = "./modules/pl_share"
  for_each  = local.pl_share
  share_arn = aws_ram_resource_share.pl[each.key].id
  principal = each.value.pl_share_principal_list
}

