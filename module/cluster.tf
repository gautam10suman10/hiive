resource "aws_eks_cluster" "clusterName" {
  name     = var.clusterName
  role_arn = aws_iam_role.eks_cluster.arn
  version  = 1.31
  vpc_config {
    subnet_ids              = [aws_subnet.subnet-zone-a.id, aws_subnet.subnet-zone-b.id]
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_vpc_security_group_ingress_rule.allow_tls_ipv4.id]
  }
}