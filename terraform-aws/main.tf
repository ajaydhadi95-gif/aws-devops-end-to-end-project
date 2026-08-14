module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "security_group" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}

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

resource "aws_iam_role_policy" "jenkins" {
  name = "jenkins-deployment-policy"
  role = aws_iam_role.jenkins.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
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

resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins-ec2-instance-profile"

  role = aws_iam_role.jenkins.name
}
module "jenkins_ec2" {

  source = "./modules/EC2_deployment"

  ami_id               = var.ami_id
  instance_type        = "t3.medium"
  subnet_id            = module.vpc.public_subnet_id
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  key_name = "Dhadi"

  instance_name = "jenkins-server"
}