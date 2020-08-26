resource "aws_eks_cluster" "cluster" {
  name     = "${var.project_name}_eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.17"

  vpc_config {
    subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  }

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
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.cluster.name
}

//ROLE
resource "aws_iam_role" "eks_node" {
  name = "${var.project_name}_eks-node"

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
resource "aws_iam_role_policy_attachment" "eks_node-ElasticLoadBalancingReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
  role       = aws_iam_role.eks_node.name
}
resource "aws_iam_policy" "security_group" {
  name        = "securityGroup"

  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeStaleSecurityGroups",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_node-securityGroup" {
  policy_arn = aws_iam_policy.security_group.arn
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}_eks-cluster"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}