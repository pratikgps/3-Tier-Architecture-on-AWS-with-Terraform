module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  ezs = var.ezs
  name = "my-vpc"
}

module "ecs" {
  source = "./modules/ecs"
  name          = "my-ecs"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  alb_target_group = module.alb.target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id
}

module "alb" {
  source         = "./modules/alb"
  name           = "my-alb"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets


}

module "rds" {
  source = "./modules/rds"

  name                  = "myrds"
  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.private_subnets

  ecs_security_group_id = module.ecs.ecs_security_group_id

  db_username = "dbuser"
  db_password = "StrongPassword123!"
}

