variable "number_of_instances" {
  default = "1"
}

variable "ingress_ports" {
  type = "list"
  default = []
}

variable "ingress_cidr_blocks" {
  type = "list"
  default = []
}
