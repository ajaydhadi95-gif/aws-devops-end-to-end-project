output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = module.vpc.public_subnet_2_id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.security_group.security_group_id
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = module.ec2.public_ip
}

output "ec2_private_ip" {
  description = "EC2 Private IP"
  value       = module.ec2.private_ip
}

output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "S3 Bucket ARN"
  value       = module.s3.bucket_arn
}

# ==================================================
# Jenkins EC2 Outputs
# ==================================================

output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = module.jenkins_ec2.instance_id
}

output "jenkins_public_ip" {
  description = "Jenkins EC2 public IP"
  value       = module.jenkins_ec2.public_ip
}

output "jenkins_public_dns" {
  description = "Jenkins EC2 public DNS"
  value       = module.jenkins_ec2.public_dns
}

output "jenkins_private_ip" {
  description = "Jenkins EC2 private IP"
  value       = module.jenkins_ec2.private_ip
}

output "frontend_ecr_repository_url" {
  value = module.ecr.frontend_repository_url
}

output "backend_ecr_repository_url" {
  value = module.ecr.backend_repository_url
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  description = "EKS node group name"
  value       = module.eks.node_group_name
}