variable "environment" {
  type = string
}
variable "branch" {
  type = string
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