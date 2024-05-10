resource "aws_ram_principal_association" "pl" {
  count              = length(var.principal)
  resource_share_arn = var.share_arn
  principal          = var.principal[count.index]
}
