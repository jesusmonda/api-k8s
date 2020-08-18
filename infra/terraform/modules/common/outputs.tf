// EKS
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

// SECRET MANAGER
output "secretsmanager" {
  value = jsondecode(data.aws_secretsmanager_secret_version.main.secret_string)
}

// VPC && SUBNET
output "vpc_id" {
  value = aws_vpc.vpc.id
}

//IAM
output "iam_codebuild_arn" {
  value = aws_iam_role.codebuild.arn
}