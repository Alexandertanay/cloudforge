# =========================
# VPC Module
# =========================

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "cloudforge-vpc"

  environment = "dev"

  public_subnet_1_cidr  = "10.0.1.0/24"
  public_subnet_2_cidr  = "10.0.2.0/24"
  private_subnet_1_cidr = "10.0.11.0/24"
  private_subnet_2_cidr = "10.0.12.0/24"

  az_1 = "ap-south-1a"
  az_2 = "ap-south-1b"
}


# =========================
# EC2 Module
# =========================

module "ec2" {
  source = "./modules/ec2"

  ami_id        = "ami-050c78efa486a0196"
  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnet_1_id
  vpc_id    = module.vpc.vpc_id

  environment = "dev"
}


# =========================
# Terraform State Refactoring
# =========================

moved {
  from = aws_vpc.cloudforge_vpc
  to   = module.vpc.aws_vpc.this
}

moved {
  from = aws_subnet.public_1
  to   = module.vpc.aws_subnet.public_1
}

moved {
  from = aws_subnet.public_2
  to   = module.vpc.aws_subnet.public_2
}

moved {
  from = aws_subnet.private_1
  to   = module.vpc.aws_subnet.private_1
}

moved {
  from = aws_subnet.private_2
  to   = module.vpc.aws_subnet.private_2
}

moved {
  from = aws_internet_gateway.cloudforge_igw
  to   = module.vpc.aws_internet_gateway.this
}

moved {
  from = aws_route_table.public
  to   = module.vpc.aws_route_table.public
}

moved {
  from = aws_route_table_association.public_1
  to   = module.vpc.aws_route_table_association.public_1
}

moved {
  from = aws_route_table_association.public_2
  to   = module.vpc.aws_route_table_association.public_2
}

moved {
  from = aws_security_group.cloudforge_ec2_sg
  to   = module.ec2.aws_security_group.this
}

moved {
  from = aws_instance.cloudforge_app
  to   = module.ec2.aws_instance.this
}