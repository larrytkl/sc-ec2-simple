output "security_group_id" {
  value = "${aws_security_group.default.id}"
}

output "ami_id" {
  value = "${data.aws_ami.app_ami.id}"
}

output "instance_id" {
  value = "${aws_instance.web.id}}"
}