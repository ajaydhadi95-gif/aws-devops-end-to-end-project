variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.12.0/24"
}

variable "availability_zone_1" {
  type    = string
  default = "ap-south-1a"
}

variable "availability_zone_2" {
  type    = string
  default = "ap-south-1b"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "devops-cluster"
}

variable "eks_node_instance_type" {
  description = "EKS node instance type"
  type        = string
  default     = "t3.medium"
}

variable "eks_node_desired_size" {
  description = "Desired EKS nodes"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Minimum EKS nodes"
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum EKS nodes"
  type        = number
  default     = 3
}
