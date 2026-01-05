provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../../modules/network"

  vpc_cidr = var.vpc_cidr
}

module "app" {
  source = "../../modules/app"

  subnet_id = module.network.public_subnet_ids
  public_sg_id = module.network.public_sg_id

  key_name = var.key_name
}

module "db" {
  source = "../../modules/db"

  subnet_id = module.network.private_subnet_id
  security_group_id = module.network.private_sg_id

  key_name = var.key_name
}
