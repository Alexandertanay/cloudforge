variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet where the EC2 instance will be deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}

variable "environment" {
  type        = string
  description = "Environment name"
}
variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile attached to the EC2 instance"
}