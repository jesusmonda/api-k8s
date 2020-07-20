variable "aws" {
  type = object({
    access_key = string
    secret_key = string
    region = string
  })
}

variable "config" {
  type = object({
    project_name = string
    github_token = string
    docker_user = string
    docker_token = string
  })
}

variable "environment_variable" {
  type = object({
    app_name = string
  })
}
