output "kubernete_namespace" {
  value      = {}
  depends_on = [kubernetes_namespace.main]
}