variable "number_of_instances" {
  default = "1"
}

variable "ingress_ports" {
  type = "list"
  default = ["22","80"]
}

variable "ingress_cidr_blocks" {
  type = "list"
  default = ["54.191.190.104/32","54.191.190.104/32"]
}

variable "cd_app_name" {
  description = "Application name for CodeDeploy"
}

variable "cd_group_name" {
  description = "Deployment group name for CodeDeploy"
}
