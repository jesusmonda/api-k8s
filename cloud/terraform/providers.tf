provider "aws" {
  version    = "~> 2.0"
  region     = var.aws.region
  access_key = var.aws.access_key
  secret_key = var.aws.secret_key
}

provider "kubernetes" {
  load_config_file       = false
  host                   = module.common.eks_cluster_endpoint
  token                  = module.common.eks_cluster_token
  cluster_ca_certificate = base64decode(module.common.eks_cluster_certificate_authority)
}