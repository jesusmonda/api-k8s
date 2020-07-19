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
  })
}

variable "environment_variable" {
  type = object({
    name = string
  })
}
