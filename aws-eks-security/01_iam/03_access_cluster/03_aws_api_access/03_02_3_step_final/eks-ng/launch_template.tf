resource "aws_launch_template" "workers" {
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      iops                  = var.workers_disk_iops
      throughput            = var.workers_disk_throughput
      volume_size           = var.workers_disk_size
      volume_type           = var.workers_disk_type
    }
  }
  ebs_optimized = var.workers_ebs_optimized
  description   = "EKS Managed Node Group for ${var.node_group_name}"
  instance_type = var.workers_instance_type
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = var.metadata_options.http_endpoint
    http_protocol_ipv6          = var.metadata_options.http_protocol_ipv6
    http_put_response_hop_limit = var.metadata_options.http_put_response_hop_limit
    http_tokens                 = var.metadata_options.http_tokens
    instance_metadata_tags      = var.metadata_options.instance_metadata_tags
  }
  monitoring {
    enabled = var.workers_enable_monitoring
  }
  name = var.node_group_name
  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups = [
      var.workers_security_group_id
    ]
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      data.aws_default_tags.aws_tags.tags,
      { "Name" : var.node_group_name },
      var.additional_tags...
    )
  }
  tag_specifications {
    resource_type = "network-interface"
    tags = merge(
      data.aws_default_tags.aws_tags.tags,
      { "Name" : var.node_group_name },
      var.additional_tags...
    )
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      data.aws_default_tags.aws_tags.tags,
      { "Name" : var.node_group_name },
      var.additional_tags...
    )
  }
  tags = merge(
    data.aws_default_tags.aws_tags.tags,
    { "Name" : var.node_group_name },
    var.additional_tags...
  )
  update_default_version = var.ng_update_default_version
}
