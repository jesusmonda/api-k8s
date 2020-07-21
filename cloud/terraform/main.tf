module "feature" {
  source = "./modules/app"

  // module
  eks_cluster_name = module.common.eks_cluster_name

  environment  = "feature"
  branch       = "feature/*"
  aws = var.aws
  config = var.config
  environment_variable = var.environment_variable
}

module "develop" {
  source = "./modules/app"

  // module
  eks_cluster_name = module.common.eks_cluster_name

  environment  = "develop"
  branch       = "develop"
  aws = var.aws
  config = var.config
  environment_variable = var.environment_variable
}

module "staging" {
  source = "./modules/app"

  // module
  eks_cluster_name = module.common.eks_cluster_name

  environment  = "staging"
  branch       = "release"
  aws = var.aws
  config = var.config
  environment_variable = var.environment_variable
}

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
