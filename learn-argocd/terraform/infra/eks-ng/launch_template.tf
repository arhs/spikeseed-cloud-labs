resource "aws_launch_template" "workers" {
  #checkov:skip=CKV_AWS_79:Ensure Instance Metadata Service Version 1 is not enabled
  name                   = var.node_group_name
  description            = "EKS Managed Node Group for ${var.node_group_name}"
  update_default_version = var.ng_update_default_version

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.workers_disk_size
      volume_type           = var.workers_disk_type
      iops                  = var.workers_disk_iops
      throughput            = var.workers_disk_throughput
      delete_on_termination = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  ebs_optimized = var.workers_ebs_optimized

  instance_type = var.workers_instance_type

  monitoring {
    enabled = var.workers_enable_monitoring
  }

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
    resource_type = "volume"

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

  tags = merge(
    data.aws_default_tags.aws_tags.tags,
    { "Name" : var.node_group_name },
    var.additional_tags...
  )

  lifecycle {
    create_before_destroy = true
  }
}
