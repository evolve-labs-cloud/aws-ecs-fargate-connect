resource "aws_iam_role" "fargate_connect" {
  name               = "fagate_connect"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "geral_policy" {
  name = "geral_ecs"
  role = aws_iam_role.fargate_connect.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:*",
          "ecs:*",
          "elasticache:*",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"

        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = "fargate-connect-stg"
  role = aws_iam_role.fargate_connect.name
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

locals {
  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]


}

resource "aws_iam_role_policy_attachment" "fargate_connect_role_policy" {
  count = length(local.role_policy_arns)

  role       = aws_iam_role.fargate_connect.name
  policy_arn = element(local.role_policy_arns, count.index)
}
