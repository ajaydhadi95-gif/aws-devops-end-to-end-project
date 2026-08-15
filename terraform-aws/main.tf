module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr_1  = var.public_subnet_cidr_1
  public_subnet_cidr_2  = var.public_subnet_cidr_2
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}


module "security_group" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_1_id
  security_group_id = module.security_group.security_group_id
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}


# ==================================================
# Jenkins IAM Role
# ==================================================

resource "aws_iam_role" "jenkins" {
  name = "jenkins-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


# ==================================================
# Jenkins IAM Policy
# ==================================================

resource "aws_iam_role_policy" "jenkins" {
  name = "jenkins-deployment-policy"
  role = aws_iam_role.jenkins.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      # ECR Authentication
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      # ECR Push/Pull
      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ]

        Resource = "*"
      },

      # EKS Access
      {
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]

        Resource = "*"
      }
    ]
  })
}


# ==================================================
# Jenkins Instance Profile
# ==================================================

resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins-ec2-instance-profile"

  role = aws_iam_role.jenkins.name
}


# ==================================================
# Jenkins EC2
# ==================================================

module "jenkins_ec2" {
  source = "./modules/EC2_deployment"

  ami_id               = var.ami_id
  instance_type        = "t3.medium"
  subnet_id            = module.vpc.public_subnet_1_id
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  key_name = "Dhadi"

  instance_name = "jenkins-server"
}


# ==================================================
# ECR
# ==================================================

module "ecr" {
  source = "./modules/ecr"
}
module "eks" {
  source = "./modules/eks"

  cluster_name = var.eks_cluster_name

  private_subnet_ids = [
    module.vpc.private_subnet_1_id,
    module.vpc.private_subnet_2_id
  ]

  node_instance_type = var.eks_node_instance_type

  desired_size = var.eks_node_desired_size
  min_size     = var.eks_node_min_size
  max_size     = var.eks_node_max_size
}