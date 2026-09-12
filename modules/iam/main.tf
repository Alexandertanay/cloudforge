# =========================
# CloudForge EC2 IAM Role
# =========================

resource "aws_iam_role" "ec2_role" {
  name = "cloudforge-ec2-role"

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

  tags = {
    Name        = "cloudforge-ec2-role"
    Environment = var.environment
    Project     = "CloudForge"
  }
}


# =========================
# ECR Pull Permissions
# =========================

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# =========================
# EC2 Instance Profile
# =========================

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "cloudforge-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "cloudforge-ec2-profile"
    Environment = var.environment
    Project     = "CloudForge"
  }
}