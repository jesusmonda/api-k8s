resource "kubernetes_config_map" "develop" {
  metadata {
    name      = "config-develop"
    namespace = "develop"
  }

  data = {
    NODE_ENV = "develop"
    APP_NAME = "app_kobing"
  }
}

resource "kubernetes_config_map" "production" {
  metadata {
    name      = "config-production"
    namespace = "production"
  }

  data = {
    NODE_ENV = "production"
    APP_NAME = "app_kobing"
  }
}

resource "kubernetes_config_map" "feature" {
  metadata {
    name      = "config-feature"
    namespace = "feature"
  }

  data = {
    NODE_ENV = "feature"
    APP_NAME = "app_kobing"
  }
}

resource "kubernetes_config_map" "staging" {
  metadata {
    name      = "config-staging"
    namespace = "staging"
  }

  data = {
    NODE_ENV = "staging"
    APP_NAME = "app_kobing"
  }
}

resource "kubernetes_config_map" "role" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<ROLES
    - rolearn: ${aws_iam_role.codebuild.arn}
      groups:
      - system:masters
    ROLES
  }
}

resource "kubectl_manifest" "rbac-role" {
    yaml_body = file("../k8s_manifest/rbac-role.yml")
}

resource "kubectl_manifest" "external-dns" {
    yaml_body = file("../k8s_manifest/external-dns.yml")
}