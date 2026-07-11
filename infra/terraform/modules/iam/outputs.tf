output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2.name
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "eks_nodes_role_arn" {
  value = aws_iam_role.eks_nodes.arn
}
