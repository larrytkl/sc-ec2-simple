output "lb_security_group_id" {
  value = "${aws_security_group.lb_sec_group.id}"
}

output "ec2_security_group_id" {
  value = "${aws_security_group.ec2_sec_group.id}"
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

/*
output "instance_id" {
  value = "${aws_instance.web.id}"
}
*/

output "launch_config_name" {
  value = "${aws_launch_configuration.asg_lc.name}"
}

output "autoscaling_group_name" {
  value = "${aws_autoscaling_group.asg.name}"
}

output "load_balancer_dns" {
  value = "${aws_alb.alb.dns_name}"
}

