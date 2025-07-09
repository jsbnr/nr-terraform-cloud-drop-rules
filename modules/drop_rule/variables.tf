variable "account_id" { }
variable "description" { }
variable "action" { }
variable "nrql" { }
variable "name" { }
variable "nrqlCloud" {}

variable "event_type" {}
variable "filter" {}
variable "attributes" {
  type    = list(string)
  default = []
}