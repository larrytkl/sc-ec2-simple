data "null_data_source" "metadata" {
  inputs {
    seal_id    = "123456"
    aws_region = "us-west-2"
    vpc_id     = "vpc-42db3526"
    subnet_id  = "subnet-7a57430d"
    key_name = "klt-us-west-2-lab"
  }
}

provider "aws" {
  region = "${data.null_data_source.metadata.inputs["aws_region"]}"
}


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