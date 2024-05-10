variable "share_arn" {
  description = "Resource Share ARN"
  type        = string
}
variable "principal" {
  description = "Principal to share with"
  type        = list(string)
}