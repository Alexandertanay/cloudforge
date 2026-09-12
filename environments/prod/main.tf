# =========================
# CloudForge Production Environment
# =========================

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = "10.1.0.0/16"
  vpc_name = "cloudforge-prod-vpc"

  environment = "prod"

  public_subnet_1_cidr  = "10.1.1.0/24"
  public_subnet_2_cidr  = "10.1.2.0/24"
  private_subnet_1_cidr = "10.1.11.0/24"
  private_subnet_2_cidr = "10.1.12.0/24"

  az_1 = "ap-south-1a"
  az_2 = "ap-south-1b"
}

module "ec2" {
  source = "../../modules/ec2"

  ami_id        = "ami-050c78efa486a0196"
  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnet_1_id
  vpc_id    = module.vpc.vpc_id

  environment = "prod"
}