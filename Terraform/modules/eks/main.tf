data "aws_caller_identity" "current" {}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  version = "1.29"

  tags = {
    Name    = var.cluster_name
    Project = "roca"
  }
}

# Node group (nodos EC2 administrados por EKS)
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-nodes"
  node_role_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  subnet_ids      = var.subnet_ids
  instance_types  = ["t3.micro"]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  tags = {
    Name    = "${var.cluster_name}-nodes"
    Project = "roca"
  }

  depends_on = [aws_eks_cluster.this]
}

