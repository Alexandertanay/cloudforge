# =========================
# CloudForge Development Environment
# =========================


# =========================
# VPC
# =========================

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "cloudforge-dev-vpc"

  environment = "dev"

  public_subnet_1_cidr  = "10.0.1.0/24"
  public_subnet_2_cidr  = "10.0.2.0/24"
  private_subnet_1_cidr = "10.0.11.0/24"
  private_subnet_2_cidr = "10.0.12.0/24"

  az_1 = "ap-south-1a"
  az_2 = "ap-south-1b"
}


# =========================
# IAM
# =========================

module "iam" {
  source = "../../modules/iam"

  environment = "dev"
}


# =========================
# ECR
# =========================

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "cloudforge-demo"
  environment     = "dev"
}


# =========================
# EC2
# =========================

module "ec2" {
  source = "../../modules/ec2"

  ami_id        = "ami-050c78efa486a0196"
  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnet_1_id
  vpc_id    = module.vpc.vpc_id

  environment = "dev"

  instance_profile_name = module.iam.instance_profile_name
}