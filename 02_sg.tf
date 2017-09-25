######################################################
# Security group allowing ports to hit load balancer #
######################################################
resource "aws_security_group" "lb_sec_group" {
  vpc_id = "${data.null_data_source.metadata.inputs["vpc_id"]}"
  name_prefix = "lb-${data.null_data_source.metadata.inputs["seal_id"]}"

  tags {
    Name   = "APP-${data.null_data_source.metadata.inputs["seal_id"]}"
    SealId = "${data.null_data_source.metadata.inputs["seal_id"]}"
    ArbitraryTagName  = "${var.number_of_instances}"
  }
}

resource "aws_security_group_rule" "lb_ingress_rules" {
  security_group_id = "${aws_security_group.lb_sec_group.id}"
  type = "ingress"
  count = "${length(var.lb_ingress_ports)}"
  protocol = "tcp"
  from_port = "${element(var.lb_ingress_ports, count.index)}"
  to_port = "${element(var.lb_ingress_ports, count.index)}"
  cidr_blocks = ["${element(var.lb_ingress_cidr_blocks, count.index)}"]
}

resource "aws_security_group_rule" "egress_default_rule" {
  security_group_id = "${aws_security_group.lb_sec_group.id}"
  type = "egress"
  protocol = "-1"
  from_port = "0"
  to_port = "0"
  cidr_blocks = ["0.0.0.0/0"]
}

####################################################
# Security group allowing Load balancer to hit EC2 #
####################################################
resource "aws_security_group" "ec2_sec_group" {
  vpc_id = "${data.null_data_source.metadata.inputs["vpc_id"]}"
  name_prefix = "ec-${data.null_data_source.metadata.inputs["seal_id"]}"
  tags {
    Name = "APP-${data.null_data_source.metadata.inputs["seal_id"]}"
    SealId = "${data.null_data_source.metadata.inputs["seal_id"]}"
    ArbitraryTagName = "${var.number_of_instances}"
  }
}

resource "aws_security_group_rule" "ec2_egress_default_rule" {
  security_group_id = "${aws_security_group.ec2_sec_group.id}"
  type = "egress"
  protocol = "-1"
  from_port = "0"
  to_port = "0"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec_ingress_rules" {
  security_group_id = "${aws_security_group.ec2_sec_group.id}"
  type = "ingress"
  count = "${length(var.ec2_ingress_ports)}"
  protocol = "tcp"
  from_port = "${element(var.ec2_ingress_ports, count.index)}"
  to_port = "${element(var.ec2_ingress_ports, count.index)}"
  source_security_group_id = "${aws_security_group.lb_sec_group.id}"
}

resource "aws_security_group_rule" "ec2_ingress_ssh" {
  security_group_id = "${aws_security_group.ec2_sec_group.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = "22"
  to_port = "22"
  cidr_blocks = ["172.31.47.86/32"]
}
