provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/terraform-assume-role"
  }
  region = var.region

  default_tags {
    tags = {
      bu          = ""
      environment = ""
      terraform   = "true"
      layer       = "platform"
      resource    = "ec2"
      type        = "spot"
    }
  }
}

terraform {
  backend "s3" {}
}

