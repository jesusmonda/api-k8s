resource "kubernetes_config_map" "develop" {
  metadata {
    name      = "config-develop"
    namespace = "develop"
  }

  data = {
    NODE_ENV = "develop"
    APP_NAME = "app_${var.project_name}"
  }

  depends_on = [module.feature.kubernete_namespace, module.develop.kubernete_namespace, module.staging.kubernete_namespace, module.production.kubernete_namespace]
}

resource "kubernetes_config_map" "production" {
  metadata {
    name      = "config-production"
    namespace = "production"
  }

  data = {
    NODE_ENV = "production"
    APP_NAME = "app_${var.project_name}"
  }

  depends_on = [module.feature.kubernete_namespace, module.develop.kubernete_namespace, module.staging.kubernete_namespace, module.production.kubernete_namespace]
}

resource "kubernetes_config_map" "feature" {
  metadata {
    name      = "config-feature"
    namespace = "feature"
  }

  data = {
    NODE_ENV = "feature"
    APP_NAME = "app_${var.project_name}"
  }

  depends_on = [module.feature.kubernete_namespace, module.develop.kubernete_namespace, module.staging.kubernete_namespace, module.production.kubernete_namespace]
}

resource "kubernetes_config_map" "staging" {
  metadata {
    name      = "config-staging"
    namespace = "staging"
  }

  data = {
    NODE_ENV = "staging"
    APP_NAME = "app_${var.project_name}"
  }

  depends_on = [module.feature.kubernete_namespace, module.develop.kubernete_namespace, module.staging.kubernete_namespace, module.production.kubernete_namespace]
}

resource "kubernetes_config_map" "role" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<ROLES
    - groups:
      - system:masters
      rolearn: ${aws_iam_role.codebuild.arn}
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: ${aws_iam_role.eks_node.arn}
      username: system:node:{{EC2PrivateDNSName}}
    ROLES
  }

  depends_on = [aws_eks_node_group.node]
}

resource "kubectl_manifest" "rbac-role" {
  yaml_body = file("../k8s_manifest/rbac-role.yml")

  depends_on = [aws_eks_node_group.node]
}

resource "kubectl_manifest" "external-dns" {
  yaml_body = templatefile("../k8s_manifest/external-dns.yaml", {DOMAIN: var.domain, ZONEID: aws_route53_zone.primary.zone_id})

  depends_on = [aws_eks_node_group.node]
}

resource "kubectl_manifest" "eks_manager_role" {
  yaml_body = file("../k8s_manifest/eks-node-manager-role.yaml")

  depends_on = [aws_eks_node_group.node]
}

resource "kubectl_manifest" "alb_ingress_controller" {
  yaml_body = templatefile("../k8s_manifest/alb-ingress-controller.yml", {AWS_CLUSTER_NAME: aws_eks_cluster.cluster.name, VPC_ID: aws_vpc.vpc.id})

  depends_on = [aws_eks_node_group.node]
}