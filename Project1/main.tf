module "my_vpc" {
  source           = "./modules/vpc"
  vpc_name         = var.vpc_name
  vpc_cidr         = var.vpc_cidr
  pub_sub_name     = var.pub_sub_name
  pub_sub_cidr     = var.pub_sub_cidr
  pub_sub_az       = var.pub_sub_az
  private_sub_name = var.private_sub_name
  private_sub_cidr = var.private_sub_cidr
  private_sub_az   = var.private_sub_az
  igw_name         = var.igw_name
  rtb_name         = var.rtb_name
  sg_name          = var.sg_name
  sg_tag_name      = var.sg_tag_name
}



