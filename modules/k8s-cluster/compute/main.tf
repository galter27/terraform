resource "aws_instance" "k8s_nodes" {
  count               = var.node_count
  ami                 = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = var.subnet_id
  security_group_ids  = var.security_group_ids
  iam_instance_profile = var.iam_instance_profile

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp2"
  }

  tags = merge(var.tags, { Name = "k8s-node-${count.index}" })
}

output "instance_ids" {
  value = aws_instance.k8s_nodes[*].id
}
