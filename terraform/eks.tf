resource "aws_iam_role" "cluster-dani" {
  name = "cluster-dani"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "cluster-dani-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-dani.name
}

resource "aws_eks_cluster" "cluster-dani" {
  name     = "cluster-dani"
  role_arn = aws_iam_role.cluster-dani.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = [
      aws_subnet.private.id,
      aws_subnet.public.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.cluster-dani-policy]
}
