#Environment Configuration
account_id       = ""
environment      = ""
ecs_cluster_name = ""

#Network Configuration
vpc_id    = ""
subnet_id = ""


ec2_config = {
  "fargate-connect" = {
    ami                    = "ami-02dcfe5d1d39baa4e"
    instance_type          = "t4g.micro"
    spot_price             = "0.050"
    volume_size            = 8
    volume_type            = "gp3"
    name                   = "fargate-connect"
    user_data              = "ecs_connect.sh"
    termination_protection = true

    security_group_name = "sg_ecs_connect"
    description         = "Security Group para ecs connect2"
    ingress = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.5.0.0/16"] # VPC CIDR
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}
