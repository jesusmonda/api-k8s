module "feature" {
  source = "./modules/app"

  // module
  module_common = module.common

  environment = "feature"
  branch      = "feature/*"
  buildspec   = "infra/codebuild/codebuild-feature-develop.yml"
  domain = "-feature.jmonda.com"
}

module "develop" {
  source = "./modules/app"

  // module
  module_common = module.common

  environment = "develop"
  branch      = "develop"
  buildspec   = "infra/codebuild/codebuild-feature-develop.yml"
  domain = ".jmonda.com"
}

module "staging" {
  source = "./modules/app"

  // module
  module_common = module.common

  environment = "staging"
  branch      = "release"
  buildspec   = "infra/codebuild/codebuild-staging-production.yml"
  domain = "staging.jmonda.com"
}

module "production" {
  source = "./modules/app"

  // module
  module_common = module.common

  environment = "production"
  branch      = "master"
  buildspec   = "infra/codebuild/codebuild-staging-production.yml"
  domain = "jmonda.com"
}

module "common" {
  source = "./modules/common"
}