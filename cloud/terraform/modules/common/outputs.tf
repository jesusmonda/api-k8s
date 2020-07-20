output "eks_cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_token" {
  value = data.aws_eks_cluster_auth.eks_cluster.token
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.cluster.certificate_authority.0.data
}