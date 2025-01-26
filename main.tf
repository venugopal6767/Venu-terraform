provider "aws" {
  version = "~> 3.0"
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "Iam" {
    source = "./modules/Iam"
}

module "ecs" {
    source = "./modules/ecs"
    ecs_execution_role_arn   = module.iam.ecs_execution_role_arn
    ecs_security_group_id    = module.vpc.security_group_id
    private_subnet1_id       = module.vpc.private_subnet_1_id
    private_subnet2_id       = module.vpc.private_subnet_2_id
}

module "alb" {
    source = "./modules/alb"
    domain_name = "venugopalmoka.site"
    vpc_id = module.vpc.vpc_id
    ecs_security_group_id   = module.vpc.security_group_id
    private_subnet1_id      = module.vpc.private_subnet_1_id
    private_subnet2_id      = module.vpc.private_subnet_2_id
}

module "route53" {
  source = "./modules/route53"
  domain_name = "venugopalmoka.site"
  zone_id = module.alb.alb_zone_id
}