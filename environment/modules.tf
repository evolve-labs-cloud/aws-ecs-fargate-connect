module "ec2" {
  source           = "../modules/ec2"
  ec2_config       = var.ec2_config
  environment      = var.environment
  region           = var.region
  vpc_id           = var.vpc_id
  subnet_id        = var.subnet_id
  ecs_cluster_name = var.ecs_cluster_name
}
