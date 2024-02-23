resource "aws_eks_node_group" "workers" {
  ami_type        = var.ng_ami_type
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.workers_role_arn
  subnet_ids      = split(",", var.subnets)

  labels = var.k8s_labels

  launch_template {
    name    = aws_launch_template.workers.name
    version = aws_launch_template.workers.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

  scaling_config {
    desired_size = var.ng_desired_capacity
    max_size     = var.ng_max_capacity
    min_size     = var.ng_min_capacity
  }

  tags = {
    "Name" : var.node_group_name
  }

  timeouts {
    create = var.ng_create_timeout
    delete = var.ng_delete_timeout
    update = var.ng_update_timeout
  }

  version = var.cluster_version

  update_config {
    max_unavailable_percentage = var.workers_max_unavailable_percentage
    max_unavailable            = var.workers_max_unavailable
  }
}
