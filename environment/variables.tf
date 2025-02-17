variable "ec2_config" {
  type = map(object({
    ami                    = string
    instance_type          = string
    spot_price             = string
    volume_size            = string
    volume_type            = string
    name                   = string
    user_data              = string
    termination_protection = bool

    security_group_name = string
    description         = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
variable "environment" {
  type = string
}

variable "key" {
  type = string
}
variable "bucket" {
  type = string
}
variable "region" {
  type = string
}
variable "account_id" {
  type = string
}
variable "ecs_cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "subnet_id" {
  type = string
}
