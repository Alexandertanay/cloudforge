output "vpc_id" {
  description = "Production VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  description = "Production public subnet 1 ID"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "Production public subnet 2 ID"
  value       = module.vpc.public_subnet_2_id
}

output "private_subnet_1_id" {
  description = "Production private subnet 1 ID"
  value       = module.vpc.private_subnet_1_id
}

output "private_subnet_2_id" {
  description = "Production private subnet 2 ID"
  value       = module.vpc.private_subnet_2_id
}

output "ec2_instance_id" {
  description = "Production EC2 instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Production EC2 public IP"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "Production EC2 public DNS"
  value       = module.ec2.public_dns
}

output "ec2_security_group_id" {
  description = "Production EC2 security group ID"
  value       = module.ec2.security_group_id
}