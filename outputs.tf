output "pl_id" {
  description = "Prefix List ID"
  value       = { for k, v in var.pl : k => aws_ec2_managed_prefix_list.pl[k].id }
}
