data "aws_eks_cluster" "cluster" {
  name = "roca-eks"
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = "roca-eks"
  depends_on = [module.eks]
}
