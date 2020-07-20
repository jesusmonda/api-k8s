resource "aws_iam_role" "main" {
  name = "${var.config.project_name}-api-${var.environment}_codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "main" {
  role = aws_iam_role.main.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "eks:DescribeCluster"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": [
        "arn:aws:ec2:us-east-1:123456789012:network-interface/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "main" {
  name          = "${var.config.project_name}-api-${var.environment}"
  build_timeout = "10"
  queued_timeout = "60"
  service_role  = aws_iam_role.main.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

    // K8S MANIFEST
    environment_variable {
      name  = "PROJECT_NAME"
      value = var.config.project_name
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
      value = var.config.docker_user
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "DOCKER_TOKEN"
      value = var.config.docker_token
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "AWS_ACCESS_KEY"
      value = var.aws.access_key
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "AWS_SECRET_KEY"
      value = var.aws.secret_key
      type  = "PLAINTEXT"
    }
  
    environment_variable {
      name  = "AWS_REGION"
      value = var.aws.region
      type  = "PLAINTEXT"
    }
    
    environment_variable {
      name  = "AWS_CLUSTER_NAME"
      value = var.eks_cluster_name
      type  = "PLAINTEXT"
    }
  
    // ENVIRONMENT API
    environment_variable {
      name  = "NODE_ENV"
      value = var.environment
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "APP_NAME"
      value = var.environment_variable.app_name
      type  = "PLAINTEXT"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/jesusmonda/terraform-rancher.git"
    git_clone_depth = 25
    buildspec = "cloud/codebuild/codebuild-${var.environment}.yml"
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
      pattern = "refs/heads/master"
    }
  }
}
resource "aws_codebuild_source_credential" "main" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.config.github_token
}