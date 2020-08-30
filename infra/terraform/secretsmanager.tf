data "aws_secretsmanager_secret" "main" {
  name = "${var.project_name}_credentials"
}

data "aws_secretsmanager_secret_version" "main" {
  secret_id = data.aws_secretsmanager_secret.main.id
}