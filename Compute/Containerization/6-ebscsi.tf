# EBS KMS encryption

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

module "ebs_kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.5"

  description = "Customer managed key to encrypt EKS node group volumes"

  # Policy
  key_administrators = [
    data.aws_caller_identity.current.arn
  ]

  key_service_roles_for_autoscaling = [
    # required for the ASG to manage encrypted volumes for nodes
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    # required for the cluster / persistentvolume-controller to create encrypted PVCs
    module.eks.cluster_iam_role_arn,
  ]

  # Aliases
  aliases = ["eks/${var.vpc_name}-eks/ebs"]

  tags = {
    Name     = "${var.vpc_name}-eks"
    "Env_type" = "${var.env_type}"
    "Terraform" = "true" 
  }

}



# Default EBS encryption

resource "aws_ebs_encryption_by_default" "default" {
  enabled = true
}

resource "aws_ebs_default_kms_key" "default" {
  key_arn = module.ebs_kms_key.key_arn
}

# IAM EBS CSI Driver

resource "aws_iam_role" "eks_ebs_csi_driver" {
  name = "AmazonEKS_EBS_CSI_DRIVER-${var.vpc_name}-eks"
  depends_on = [module.eks]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "${module.eks.oidc_provider_arn}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
  tags = {
    Name     = "${var.vpc_name}-eks"
    "Env_type" = "${var.env_type}"
    "Terraform" = "true" 
  }
}



resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_policy" "eks_ebs_csi_driver_kms" {
  name = "KMS_Key_For_Encryption_On_EBS-${var.vpc_name}-eks"
  tags = {
    Name     = "${var.vpc_name}-eks"
    "Env_type" = "${var.env_type}"
    "Terraform" = "true" 
  }
  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Action": [
         "kms:CreateGrant",
         "kms:ListGrants",
         "kms:RevokeGrant"
       ],
      "Resource": ["${module.ebs_kms_key.key_arn}"],
       "Condition": {
         "Bool": {
           "kms:GrantIsForAWSResource": "true"
         }
       }
     },
     {
       "Effect": "Allow",
       "Action": [
         "kms:Encrypt",
         "kms:Decrypt",
         "kms:ReEncrypt*",
         "kms:GenerateDataKey*",
         "kms:DescribeKey"
       ],
       "Resource": ["${module.ebs_kms_key.key_arn}"]
     }
   ]
 }
 POLICY
 }

 resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver_kms" {
   role       = aws_iam_role.eks_ebs_csi_driver.name
   policy_arn = aws_iam_policy.eks_ebs_csi_driver_kms.arn
 }

 resource "aws_eks_addon" "csi_driver" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.28.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
}