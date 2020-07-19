resource "aws_iam_role" "main" {
  name = "${var.config.project_name}-${var.environment}-role"

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
  name          = "${var.config.project_name}-${var.environment}"
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

    environment_variable {
      name  = "NODE_ENV"
      value = var.environment
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "NAME"
      value = var.environment_variable.name
      type  = "PLAINTEXT"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/jesusmonda/terraform-rancher.git"
    git_clone_depth = 25
    buildspec = "infra/codebuild/codebuild-${var.environment}.yml"
  }

  source_version = "refs/heads/${var.branch}"
}
resource "aws_codebuild_webhook" "main" {
  project_name = aws_codebuild_project.main.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
  }
}
resource "aws_codebuild_source_credential" "main" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.config.github_token
}