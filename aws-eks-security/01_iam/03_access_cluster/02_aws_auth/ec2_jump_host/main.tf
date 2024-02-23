resource "random_shuffle" "subnet" {
  input        = var.subnets
  result_count = 1
}

resource "aws_instance" "jump_host" {
  ami                         = data.aws_ami.al2.image_id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.jump_host.name
  instance_type               = var.instance_type
  root_block_device {
    volume_size           = "8"
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
    tags = merge(
      data.aws_default_tags.aws_tags.tags,
      {
        Application = "jump-host"
        Name        = "${var.name_prefix}-jump-host"
      }
    )
  }
  subnet_id = random_shuffle.subnet.result[0]
  tags = merge(
    data.aws_default_tags.aws_tags.tags,
    {
      Application = "jump-host"
      Name        = "${var.name_prefix}-jump-host"
    }
  )
  user_data = templatefile("${path.module}/jump_host_user_data.tpl",
    {
      k8s_version  = data.http.k8s_latest_version.response_body
      aws_region   = data.aws_region.current.name
      cluster_name = var.cluster_name
  })
  vpc_security_group_ids = [
    aws_security_group.jump_host_sg.id,
  ]
}
