output "security_group_id" {
  value = "${aws_security_group.default.id}"
}

output "ami_id" {
  value = "${data.aws_ami.app_ami.id}"
}

output "code_deploy_application_name" {
  value = "${aws_codedeploy_app.code_deploy_app.name}"
}

output "code_deploy_deployment_group_name" {
  value = "${aws_codedeploy_deployment_group.code_deploy_app_deploy_group.deployment_group_name}"
}

output "instance_id" {
  value = "${aws_instance.web.id}}"
}
