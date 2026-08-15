variable "frontend_repository_name" {
  description = "Frontend ECR repository name"
  type        = string
  default     = "devops-frontend"
}

variable "backend_repository_name" {
  description = "Backend ECR repository name"
  type        = string
  default     = "devops-backend"
}