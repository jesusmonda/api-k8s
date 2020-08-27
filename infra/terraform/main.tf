module "feature" {
  source = "./modules/app"

  environment    = "feature"
  branch         = "feature/*"
  buildspec      = "infra/codebuild/codebuild-feature-develop.yml"
  domain         = "-feature.jmonda.com"
  data_resources = { cluster_name : aws_eks_cluster.cluster.name, project_name : var.project_name, secretsmanager : jsondecode(data.aws_secretsmanager_secret_version.main.secret_string), iam_codebuild_arn : aws_iam_role.codebuild.arn }
}

module "develop" {
  source = "./modules/app"

  environment    = "develop"
  branch         = "develop"
  buildspec      = "infra/codebuild/codebuild-feature-develop.yml"
  domain         = ".jmonda.com"
  data_resources = { cluster_name : aws_eks_cluster.cluster.name, project_name : var.project_name, secretsmanager : jsondecode(data.aws_secretsmanager_secret_version.main.secret_string), iam_codebuild_arn : aws_iam_role.codebuild.arn }
}

module "staging" {
  source = "./modules/app"

  environment    = "staging"
  branch         = "release"
  buildspec      = "infra/codebuild/codebuild-staging-production.yml"
  domain         = "staging.jmonda.com"
  data_resources = { cluster_name : aws_eks_cluster.cluster.name, project_name : var.project_name, secretsmanager : jsondecode(data.aws_secretsmanager_secret_version.main.secret_string), iam_codebuild_arn : aws_iam_role.codebuild.arn }
}

module "production" {
  source = "./modules/app"

  environment    = "production"
  branch         = "master"
  buildspec      = "infra/codebuild/codebuild-staging-production.yml"
  domain         = "jmonda.com"
  data_resources = { cluster_name : aws_eks_cluster.cluster.name, project_name : var.project_name, secretsmanager : jsondecode(data.aws_secretsmanager_secret_version.main.secret_string), iam_codebuild_arn : aws_iam_role.codebuild.arn }
}