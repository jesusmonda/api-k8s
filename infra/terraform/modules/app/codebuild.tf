resource "aws_codebuild_project" "main" {
  name           = "${var.data_resources.project_name}-api-${var.environment}"
  build_timeout  = "10"
  queued_timeout = "60"
  service_role   = var.data_resources.iam_codebuild_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    // K8S MANIFEST
    environment_variable {
      name  = "PROJECT_NAME"
      value = var.data_resources.project_name
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "DOMAIN"
      value = var.domain
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "VPC_ID"
      value = var.data_resources.vpc_id
      type  = "PLAINTEXT"
    }

    // CODEBUILD
    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "DOCKER_USER"
      value = "jesusmonda"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "DOCKER_TOKEN"
      value = var.data_resources.secretsmanager.docker_token
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "AWS_CLUSTER_NAME"
      value = var.data_resources.cluster_name
      type  = "PLAINTEXT"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/jesusmonda/api-k8s.git"
    git_clone_depth = 25
    buildspec       = var.buildspec
  }
}
resource "aws_codebuild_webhook" "main" {
  project_name = aws_codebuild_project.main.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "refs/heads/${var.branch}"
    }
  }
}

resource "aws_codebuild_source_credential" "main" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.data_resources.secretsmanager.github_token
}