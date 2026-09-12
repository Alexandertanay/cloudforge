# =========================
# VPC Outputs
# =========================

output "vpc_id" {
  description = "Development VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  description = "Development public subnet 1 ID"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "Development public subnet 2 ID"
  value       = module.vpc.public_subnet_2_id
}

# =========================
# Private Subnet Outputs
# =========================

output "private_subnet_1_id" {
  description = "Development private subnet 1 ID"
  value       = module.vpc.private_subnet_1_id
}

output "private_subnet_2_id" {
  description = "Development private subnet 2 ID"
  value       = module.vpc.private_subnet_2_id
}

# =========================
# EC2 Outputs
# =========================

output "ec2_instance_id" {
  description = "Development EC2 instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Development EC2 public IP"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "Development EC2 public DNS"
  value       = module.ec2.public_dns
}

# =========================
# Security Group
# =========================

output "ec2_security_group_id" {
  description = "Development EC2 security group ID"
  value       = module.ec2.security_group_id
}
# =========================
# ECR Outputs
# =========================

output "ecr_repository_name" {
  description = "ECR repository name"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ECR repository ARN"
  value       = module.ecr.repository_arn
}