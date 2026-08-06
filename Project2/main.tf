module "VPC" {
  source      = "./modules/VPC"
  environment = local.env
}

module "frontend" {
  source            = "./modules/frontend_ec2"
  subnet_ids        = module.VPC.public_subnet_ids
  security_group_id = module.VPC.security_group_id
  environment       = local.env
}


module "backend" {
  source                    = "./modules/backend_ec2"
  priv_subnet_ids           = module.VPC.private_subnet_ids
  backend_security_group_id = module.VPC.backend_security_group_id
  environment               = local.env
}

module "ALB" {
  source            = "./modules/ALB"
  environment       = local.env
  vpc_id            = module.VPC.vpc_id
  public_subnet_ids = module.VPC.public_subnet_ids
  security_group_id = module.VPC.alb_security_group_id
  instance_ids      = module.frontend.instance_ids
}


module "RDS" {
  source                = "./modules/RDS"
  environment           = local.env
  vpc_id                = module.VPC.vpc_id
  db_subnet_ids         = module.VPC.db_subnet_ids
  rds_security_group_id = module.VPC.rds_security_group_id
  db_username           = var.db_username
  db_password           = var.db_password
}