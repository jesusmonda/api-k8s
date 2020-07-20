resource "kubernetes_namespace" "main" {
  metadata {
    annotations = {
      name = var.environment
    }

    name = var.environment
  }
}