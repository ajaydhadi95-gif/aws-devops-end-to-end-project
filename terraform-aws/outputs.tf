output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.vpc.public_subnet_id
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