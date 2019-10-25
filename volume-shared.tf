data "ignition_filesystem" "shared" {
  mount {
    device = "/dev/xvdg"
    format = "ext4"
    label  = "shared"
  }
}

resource "aws_volume_attachment" "shared" {
  device_name  = "/dev/xvdg"
  volume_id    = aws_ebs_volume.shared.id
  instance_id  = aws_instance.main.id
  skip_destroy = true
}

resource "aws_ebs_volume" "shared" {
  availability_zone = "${data.aws_region.current.name}a"
  size              = 1
  type              = "gp2"

  tags = {
    Name = "Kubernetes Shared"
  }
}

