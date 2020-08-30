provider "aws" {
  version = "~> 2.0"
  profile = var.project_name
  region  = "eu-west-1"
}

provider "kubernetes" {
  load_config_file       = true
  host                   = aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
}

provider "kubectl" {
  load_config_file       = true
  host                   = aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
}

provider "helm" {}