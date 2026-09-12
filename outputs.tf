# =========================
# VPC Outputs
# =========================

output "vpc_id" {
  description = "CloudForge VPC ID"
  value       = module.vpc.vpc_id
}


# =========================
# Public Subnet Outputs
# =========================

output "public_subnet_1_id" {
  description = "CloudForge public subnet 1 ID"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "CloudForge public subnet 2 ID"
  value       = module.vpc.public_subnet_2_id
}


# =========================
# Private Subnet Outputs
# =========================

output "private_subnet_1_id" {
  description = "CloudForge private subnet 1 ID"
  value       = module.vpc.private_subnet_1_id
}

output "private_subnet_2_id" {
  description = "CloudForge private subnet 2 ID"
  value       = module.vpc.private_subnet_2_id
}


# =========================
# EC2 Outputs
# =========================

output "ec2_instance_id" {
  description = "CloudForge EC2 instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the CloudForge EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the CloudForge EC2 instance"
  value       = module.ec2.public_dns
}


# =========================
# Security Group Output
# =========================

output "ec2_security_group_id" {
  description = "CloudForge EC2 security group ID"
  value       = module.ec2.security_group_id
}