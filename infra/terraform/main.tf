module "feature" {
  source = "./modules/app"

  environment    = "feature"
  branch         = "feature/*"
  buildspec      = "infra/codebuild/codebuild-feature-develop.yml"
  domain         = "-feature.${var.domain}"
  data_resources = { depends_on : aws_eks_node_group.node.id, cluster_name : aws_eks_cluster.cluster.name, project_name : var.project_name, secretsmanager : jsondecode(data.aws_secretsmanager_secret_version.main.secret_string), iam_codebuild_arn : aws_iam_role.codebuild.arn }

  depends_node = aws_eks_node_group.node
}

module "develop" {
  source = "./modules/app"

  environment    = "develop"
  branch         = "develop"
  buildspec      = "infra/codebuild/codebuild-feature-develop.yml"
  domain         = ".${var.domain}"
  data_resources = { depends_on : aws_eks_node_group.node.id, cluster_name : aws_eks_cluster.cluster.name, project_name : var.project_name, secretsmanager : jsondecode(data.aws_secretsmanager_secret_version.main.secret_string), iam_codebuild_arn : aws_iam_role.codebuild.arn }

  depends_node = aws_eks_node_group.node
}

module "staging" {
  source = "./modules/app"

  environment    = "staging"
  branch         = "release"
  buildspec      = "infra/codebuild/codebuild-staging-production.yml"
  domain         = "staging.${var.domain}"
  data_resources = { depends_on : aws_eks_node_group.node.id, cluster_name : aws_eks_cluster.cluster.name, project_name : var.project_name, secretsmanager : jsondecode(data.aws_secretsmanager_secret_version.main.secret_string), iam_codebuild_arn : aws_iam_role.codebuild.arn }

  depends_node = aws_eks_node_group.node
}

module "production" {
  source = "./modules/app"

  environment    = "production"
  branch         = "master"
  buildspec      = "infra/codebuild/codebuild-staging-production.yml"
  domain         = var.domain
  data_resources = { cluster_name : aws_eks_cluster.cluster.name, project_name : var.project_name, secretsmanager : jsondecode(data.aws_secretsmanager_secret_version.main.secret_string), iam_codebuild_arn : aws_iam_role.codebuild.arn }

  depends_node = aws_eks_node_group.node
}