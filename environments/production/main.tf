module "vpc" {
  source      = "../../modules/vpc"
  branch      = var.branch
  environment = var.environment
}

module "ec2" {
  source            = "../../modules/ec2"
  branch            = var.branch
  environment       = var.environment
  subnet_public1_id = module.vpc.subnet_public1_id
  sg_rancher_id     = module.sg.sg_rancher_id
}

module "sg" {
  source      = "../../modules/sg"
  branch      = var.branch
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}