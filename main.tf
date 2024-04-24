
locals {
  name-prefix = lower("${var.org}-${var.proj}-${var.env}") // prefix for naming resources
}

data "aws_region" "current" {}

resource "aws_ec2_managed_prefix_list" "pl" {
  for_each = var.pl
  name = "${local.name-prefix}-${each.key}"
  address_family = each.value.address_family
  max_entries = each.value.max_entries
  dynamic "entry" {
    for_each = each.value.entries
    content {
      cidr = entry.value
      description = entry.key
    }
  }
}
