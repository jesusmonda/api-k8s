// CLUSTER
resource "aws_iam_role" "eks_cluster" {
  name = "${var.config.project_name}-${var.environment}-eks-cluster"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}
resource "aws_eks_cluster" "cluster" {
  name     = "${var.config.project_name}-${var.environment}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  }
}

// NODE
resource "aws_iam_role" "eks_node" {
  name = "${var.config.project_name}-${var.environment}-eks-node"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "eks_node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}
resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.config.project_name}-${var.environment}-eks-node"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.cluster.name
}