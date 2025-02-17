resource "aws_spot_instance_request" "ec2" {
  for_each                = var.ec2_config
  ami                     = each.value.ami
  spot_price              = each.value.spot_price
  instance_type           = each.value.instance_type
  wait_for_fulfillment    = "true"
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.ec2[each.key].id]
  ebs_optimized           = true
  disable_api_termination = each.value.termination_protection

  tags = {
    Name = "fargate-connect"
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_iam_instance_profile.name

  root_block_device {
    volume_size = each.value.volume_size
    volume_type = each.value.volume_type
    encrypted   = true
  }


  user_data = templatefile("${path.module}/userdata/ecs_connect.sh",
    {
      ECS_CLUSTER_NAME = var.ecs_cluster_name,
      ECS_REGION       = var.region
  })
}

