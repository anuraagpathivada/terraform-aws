resource "aws_iam_role" "accesstocluster" {
  for_each = toset(["single"])

  name = "${var.vpc_name}-${each.key}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com",
                "AWS": "arn:aws:iam::023408401842:user/${var.eks_user_for_access}"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})

  tags = {
    Name     = "${var.vpc_name}-eks"
    "Env_type" = "${var.env_type}"
  }
}