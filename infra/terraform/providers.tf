provider "aws" {
  version    = "~> 2.0"
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
}