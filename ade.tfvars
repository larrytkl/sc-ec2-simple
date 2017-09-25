# warning: somehow this file is not loaded during `tf push` with `-var-file`
number_of_instances="1"
lb_ingress_ports=["80"]
lb_ingress_cidr_blocks=["54.191.190.104/32"]
cd_app_name="tfe-klt-app"
cd_group_name="tfe-klt-app-deploy-group"
ec2_ingress_ports=["80"]