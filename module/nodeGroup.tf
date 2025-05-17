resource "aws_launch_template" "eks-template" {
  name                   = var.templateName
  vpc_security_group_ids = [aws_vpc_security_group_ingress_rule.allow_tls_ipv4.id]

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 50
      volume_type = "gp2"
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name         = "${var.clusterName}-nodegroup"
      "c1:env"     = var.env
      "c1:cluster" = aws_eks_cluster.clusterName.name
    }
  }
}

resource "aws_eks_node_group" "worker" {
  cluster_name    = aws_eks_cluster.clusterName.name
  node_group_name = "${var.clusterName}-nodegroup"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  scaling_config {
    desired_size = 1
    max_size     = var.max_instance
    min_size     = 1
  }
  launch_template {
    id      = aws_launch_template.eks-template.id
    version = "$Latest"
  }

  capacity_type  = "SPOT"
  instance_types = var.instanceType
  subnet_ids     = [aws_subnet.subnet-zone-a.id, aws_subnet.subnet-zone-b.id]
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.autoscaling,
    aws_iam_role_policy_attachment.loadbalance,
  ]
}

resource "null_resource" "kube_config" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.clusterName}"
  }
  depends_on = [
    aws_eks_node_group.worker
  ]
}