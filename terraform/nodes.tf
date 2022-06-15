resource "aws_iam_role" "workers-group" {
  name = "eks-node-workers-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "workers-group-worker-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers-group.name
}

resource "aws_iam_role_policy_attachment" "workers-group-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workers-group.name
}

resource "aws_iam_role_policy_attachment" "workers-group-read-only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers-group.name
}

resource "aws_eks_node_group" "cluster-dani-nodes" {
  cluster_name    = aws_eks_cluster.cluster-dani.name
  node_group_name = "cluster-dani-nodes"
  node_role_arn   = aws_iam_role.workers-group.arn

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.public.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.medium"]

  scaling_config {
    desired_size = 3
    max_size     = 7
    min_size     = 3
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.workers-group-worker-policy,
    aws_iam_role_policy_attachment.workers-group-cni-policy,
    aws_iam_role_policy_attachment.workers-group-read-only,
  ]
}
