resource "aws_eks_cluster" "cluster" {
  name     = "${var.project_name}_eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.17"

  vpc_config {
    subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  }

  depends_on = [aws_nat_gateway.gw, aws_internet_gateway.gw]
}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.project_name}_eks-node"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = [aws_subnet.private1.id, aws_subnet.private2.id, aws_subnet.private3.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [aws_nat_gateway.gw, aws_internet_gateway.gw]
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.cluster.name
}