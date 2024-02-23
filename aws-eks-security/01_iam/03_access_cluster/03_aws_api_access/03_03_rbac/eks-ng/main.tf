resource "aws_eks_node_group" "workers" {
  ami_type     = var.ng_ami_type
  cluster_name = var.cluster_name
  labels       = var.k8s_labels
  launch_template {
    name    = aws_launch_template.workers.name
    version = aws_launch_template.workers.latest_version
  }
  lifecycle {
    create_before_destroy = true
  }
  node_group_name = var.node_group_name
  node_role_arn   = var.workers_role_arn
  scaling_config {
    desired_size = var.ng_desired_capacity
    max_size     = var.ng_max_capacity
    min_size     = var.ng_min_capacity
  }
  subnet_ids = split(",", var.subnets)
  tags = {
    "Name" : var.node_group_name
  }
  timeouts {
    create = var.ng_create_timeout
    delete = var.ng_delete_timeout
    update = var.ng_update_timeout
  }
  update_config {
    max_unavailable            = var.workers_max_unavailable
    max_unavailable_percentage = var.workers_max_unavailable_percentage
  }
  version = var.cluster_version
}
