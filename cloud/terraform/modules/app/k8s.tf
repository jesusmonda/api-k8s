resource "kubernetes_namespace" "main" {
  metadata {
    annotations = {
      name = var.environment
    }

    name = var.environment
  }
}

resource "kubernetes_config_map" "main" {
  metadata {
    name = "config-${var.environment}"
  }

  data = {
    NODE_ENV = var.environment
    APP_NAME = var.environment_variable.app_name
  }
}