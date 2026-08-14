variable "ami_id" {
  description = "Ubuntu 24.04 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "EC2 subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "EC2 security group ID"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  type        = string
}

variable "key_name" {
  description = "EC2 SSH key pair"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "jenkins-server"
}