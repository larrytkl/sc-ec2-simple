variable "number_of_instances" {
  default = "2"
}

variable "lb_ingress_ports" {
  description = "Load balancer's internet facing ports"
  type = "list"
  default = []
}

variable "lb_ingress_cidr_blocks" {
  description = "Allowed ips to hit load balancer"
  type = "list"
  default = []
}

variable "ec2_ingress_ports" {
  description = "Allowed ports to be hit from load balancer to EC2."
  type = "list"
  default = []
}

variable "cd_app_name" {
  description = "Application name for CodeDeploy"
}

variable "cd_group_name" {
  description = "Deployment group name for CodeDeploy"
}
