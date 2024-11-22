resource "aws_ebs_volume" "data" {
  count        = var.volume_count
  availability_zone = var.availability_zone
  size         = var.size
  type         = "gp2"
  tags         = var.tags
}

resource "aws_ebs_volume_attachment" "ebs_attach" {
  count          = var.volume_count
  device_name    = "/dev/xvd${count.index}"
  instance_id    = var.instance_ids[count.index]
  volume_id      = aws_ebs_volume.data[count.index].id
}
