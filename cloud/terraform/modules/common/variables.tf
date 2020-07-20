variable "config" {
  type = object({
    project_name = string
    github_token = string
    docker_user = string
    docker_token = string
  })
}