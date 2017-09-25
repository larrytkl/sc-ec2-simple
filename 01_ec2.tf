data "null_data_source" "metadata" {
  inputs {
    seal_id    = "123456"
    aws_region = "us-west-2"
    vpc_id     = "vpc-42db3526"
    subnet_id  = "subnet-7a57430d"
    subnet_id_2b  = "subnet-a913e3cd"
    #    instance_profile = "arn:aws:iam::341947552535:instance-profile/templateiaas-klt-CodeDeployDemo-EC2-Instance-Profile"
    key_name = "klt-us-west-2-lab"
    availability_zone_a = "us-west-2a"
  }
}

provider "aws" {
  region = "${data.null_data_source.metadata.inputs["aws_region"]}"
}


#data "aws_iam_instance_profile" "code_deploy" {
#  name = "templateiaas-klt-CodeDeployDemo-EC2-Instance-Profile"
#}


data "aws_ami" "app_ami" {
  most_recent      = true

  filter {
    name   = "tag:seal_id"
    values = ["${data.null_data_source.metadata.inputs["seal_id"]}"]
  }
}

data "template_file" "web-userdata" {
  template = "${file("${path.module}/code-deploy.user-data")}"
}

# Create the instance
/*
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.app_ami.id}"
  instance_type = "t2.micro"
  subnet_id = "${data.null_data_source.metadata.inputs["subnet_id"]}"
  security_groups = ["${aws_security_group.default.id}"]
  user_data = "${data.template_file.web-userdata.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.code_deploy_ec2_instance_profile.name}"
  associate_public_ip_address = true
  key_name = "${data.null_data_source.metadata.inputs["key_name"]}"

  tags {
    seal_id = "${data.null_data_source.metadata.inputs["seal_id"]}"
  }
}
*/

resource "aws_alb_target_group" "alb_tg" {
  name = "${data.null_data_source.metadata.inputs["seal_id"]}-${var.cd_app_name}-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.null_data_source.metadata.inputs["vpc_id"]}"

  health_check {
    protocol = "HTTP"
    path = "/index.html"
    port = "traffic-port"
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
  }

  tags {
    seal_id = "${data.null_data_source.metadata.inputs["seal_id"]}"
  }
}

resource "aws_alb" "alb" {
  name = "${data.null_data_source.metadata.inputs["seal_id"]}-${var.cd_app_name}-alb"
  subnets = ["${data.null_data_source.metadata.inputs["subnet_id"]}", "${data.null_data_source.metadata.inputs["subnet_id_2b"]}"]
  security_groups = ["${aws_security_group.lb_sec_group.id}"]

  tags = {
    seal_id = "${data.null_data_source.metadata.inputs["seal_id"]}"
  }
}


resource "aws_alb_listener" "web_alb_listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.alb_tg.arn}"
    type = "forward"
  }
}


resource "aws_launch_configuration" "asg_lc" {
  name = "${data.null_data_source.metadata.inputs["seal_id"]}-${var.cd_app_name}-${data.aws_ami.app_ami.id}"
  image_id = "${data.aws_ami.app_ami.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.ec2_sec_group.id}"]
  user_data = "${data.template_file.web-userdata.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.code_deploy_ec2_instance_profile.name}"
  key_name = "${data.null_data_source.metadata.inputs["key_name"]}"
  associate_public_ip_address = true
}


resource "aws_autoscaling_group" "asg" {
  name = "${data.null_data_source.metadata.inputs["seal_id"]}-${var.cd_app_name}-${data.aws_ami.app_ami.id}"
  min_size = 1
  max_size = "${var.number_of_instances}"
  launch_configuration = "${aws_launch_configuration.asg_lc.name}"

  vpc_zone_identifier = ["${data.null_data_source.metadata.inputs["subnet_id"]}"]
  tags = [
    {
      key = "seal_id"
      value = "${data.null_data_source.metadata.inputs["seal_id"]}"
      propagate_at_launch = true
    },
  ]
  health_check_type = "ELB"
  health_check_grace_period = 300
  target_group_arns = ["${aws_alb_target_group.alb_tg.arn}"]
}
