variable "org" {
  description = "Organization code to inlcude in resource names"
  type        = string
}
variable "proj" {
  description = "Project code to include in resource names"
  type        = string
}
variable "env" {
  description = "Environment code to include in resource names"
  type        = string
}

variable "pl" {
  description = "Prefix List with entries"
  type = map(object({
    address_family = optional(string,"IPv4")
    max_entries = number
    entries = map(string)
    tags = optional(map(string),{})
  }))
}
