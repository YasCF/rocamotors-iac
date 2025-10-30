output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "node_group_name" {
  value = aws_eks_node_group.nodes.node_group_name
}
