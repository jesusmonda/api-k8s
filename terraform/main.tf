module "develop" {
  source = "./modules/app"

  branch      = var.branch
  environment = "develop"
}

resource "kubernetes_pod" "test" {
  metadata {
    name = "terraform-example2"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "nginx"
    }
  }
}