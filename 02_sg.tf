resource "aws_security_group" "default" {
  vpc_id = "${data.null_data_source.metadata.inputs["vpc_id"]}"
  name_prefix = "${data.null_data_source.metadata.inputs["seal_id"]}"

  tags {
    Name   = "APP-${data.null_data_source.metadata.inputs["seal_id"]}"
    SealId = "${data.null_data_source.metadata.inputs["seal_id"]}"
    ArbitraryTagName  = "${var.number_of_instances}"
  }
}

resource "aws_security_group_rule" "ingress_rules" {
  security_group_id = "${aws_security_group.default.id}"
  type = "ingress"
  count = "${length(var.ingress_ports)}"
  protocol = "tcp"
  from_port = "${element(var.ingress_ports, count.index)}"
  to_port = "${element(var.ingress_ports, count.index)}"
  cidr_blocks = ["${element(var.ingress_cidr_blocks, count.index)}"]
}

resource "aws_security_group_rule" "egress_default_rule" {
  security_group_id = "${aws_security_group.default.id}"
  type = "egress"
  protocol = "-1"
  from_port = "0"
  to_port = "0"
  cidr_blocks = ["0.0.0.0/0"]
}