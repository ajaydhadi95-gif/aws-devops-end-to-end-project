resource "aws_ecr_repository" "frontend" {
  name                 = "devops-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "devops-frontend"
    Environment = "devops"
  }
}

resource "aws_ecr_repository" "backend" {
  name                 = "devops-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "devops-backend"
    Environment = "devops"
  }
}