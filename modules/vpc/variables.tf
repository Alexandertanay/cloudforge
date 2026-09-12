variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "public_subnet_1_cidr" {
  type        = string
  description = "CIDR for public subnet 1"
}

variable "public_subnet_2_cidr" {
  type        = string
  description = "CIDR for public subnet 2"
}

variable "private_subnet_1_cidr" {
  type        = string
  description = "CIDR for private subnet 1"
}

variable "private_subnet_2_cidr" {
  type        = string
  description = "CIDR for private subnet 2"
}

variable "az_1" {
  type        = string
  description = "First availability zone"
}

variable "az_2" {
  type        = string
  description = "Second availability zone"
}