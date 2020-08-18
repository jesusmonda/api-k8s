data "aws_secretsmanager_secret" "main" {
  name = "kobing_credentials"
}

data "aws_secretsmanager_secret_version" "main" {
  secret_id = data.aws_secretsmanager_secret.main.id
}