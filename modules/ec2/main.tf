# =========================
# CloudForge EC2 Security Group
# =========================

resource "aws_security_group" "this" {
  name        = "cloudforge-ec2-sg"
  description = "Security group for CloudForge EC2 instance"
  vpc_id      = var.vpc_id

  # SSH
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cloudforge-ec2-sg"
    Environment = var.environment
    Project     = "CloudForge"
  }
}


# =========================
# CloudForge EC2 Instance
# =========================

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "video-platform-key"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  associate_public_ip_address = true

  # Attach IAM instance profile
  # This allows EC2 to pull Docker images from ECR.
  iam_instance_profile = var.instance_profile_name

  # Install Docker automatically when EC2 starts
  user_data = <<-EOF
              #!/bin/bash

              # Update packages
              apt-get update -y

              # Install Docker
              apt-get install -y docker.io

              # Start Docker
              systemctl enable docker
              systemctl start docker

              # Allow the ubuntu user to use Docker
              usermod -aG docker ubuntu
              EOF

  tags = {
    Name        = "cloudforge-app"
    Environment = var.environment
    Project     = "CloudForge"
  }
}