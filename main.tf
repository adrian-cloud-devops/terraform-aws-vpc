module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  common_tags = var.common_tags
}

module "subnets" {
  source                = "./modules/subnets"
  vpc_id                = module.vpc.vpc_id
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  az_a                  = data.aws_availability_zones.available.names[0]
  az_b                  = data.aws_availability_zones.available.names[1]
  common_tags           = var.common_tags
}

module "routing" {
  source              = "./modules/routing"
  vpc_id              = module.vpc.vpc_id
  public_subnet_a_id  = module.subnets.public_subnet_a_id
  public_subnet_b_id  = module.subnets.public_subnet_b_id
  private_subnet_a_id = module.subnets.private_subnet_a_id
  private_subnet_b_id = module.subnets.private_subnet_b_id
  common_tags         = var.common_tags
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.vpc.vpc_id
  common_tags = var.common_tags
}