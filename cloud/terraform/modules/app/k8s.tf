resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = var.environment
    }

    name = var.environment
  }
}