module "production" {
  source = "./modules/app"

  // module
  eks_cluster_name = module.common.eks_cluster_name

  environment  = "production"
  branch       = "master"
  aws = var.aws
  config = var.config
  environment_variable = var.environment_variable
}

module "common" {
  source = "./modules/common"

  config = var.config
}
