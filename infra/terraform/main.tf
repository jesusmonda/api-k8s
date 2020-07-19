module "production" {
  source = "./modules/app"

  environment  = "production"
  branch       = "master"
  config = var.config
  environment_variable = var.environment_variable
}
