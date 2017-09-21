### START Service Role for CodeDeploy service
resource "aws_iam_role" "code_deploy_service_role" {
  name = "ServiceRole-${data.null_data_source.metadata.inputs["seal_id"]}-${var.cd_app_name}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "code_deploy_service_role_policy" {
  role = "${aws_iam_role.code_deploy_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
### END Service Role for CodeDeploy service

### START EC2 instance profile role and policy
resource "aws_iam_role" "code_deploy_ec2_instance_profile" {
  name = "CodeDeploy-EC2-instance-profile-role-${data.null_data_source.metadata.inputs["seal_id"]}-${var.cd_app_name}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "code_deploy_ec2_permissions" {
  name = "EC-Permissions-${data.null_data_source.metadata.inputs["seal_id"]}-${var.cd_app_name}"
  role = "${aws_iam_role.code_deploy_ec2_instance_profile.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "code_deploy_ec2_instance_profile" {
  name = "CodeDeploy-EC2-instance-profile-${data.null_data_source.metadata.inputs["seal_id"]}-${var.cd_app_name}"
  role = "${aws_iam_role.code_deploy_ec2_instance_profile.name}"
}
### END EC2 instance profile role and policy

### START CodeDeploy App, and Deployment Group
resource "aws_codedeploy_app" "code_deploy_app" {
  name = "${var.cd_app_name}"
}

resource "aws_codedeploy_deployment_group" "code_deploy_app_deploy_group" {
  app_name = "${aws_codedeploy_app.code_deploy_app.name}"
  deployment_group_name = "${var.cd_group_name}"
  service_role_arn = "${aws_iam_role.code_deploy_service_role.arn}"
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  ec2_tag_filter {
    key = "seal_id"
    type = "KEY_AND_VALUE"
    value = "${data.null_data_source.metadata.inputs["seal_id"]}"
  }
}
### END CodeDeploy App, and Deployment Group
