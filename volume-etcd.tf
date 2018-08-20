data "ignition_filesystem" "etcd" {
  mount {
    device = "/dev/xvdf"
    format = "ext4"
    label  = "etcd"
  }
}

resource "aws_volume_attachment" "etcd" {
  device_name  = "/dev/xvdf"
  volume_id    = "${aws_ebs_volume.etcd.id}"
  instance_id  = "${aws_instance.main.id}"
  skip_destroy = true
}

resource "aws_ebs_volume" "etcd" {
  availability_zone = "${data.aws_region.current.name}a"
  size              = 1
  type              = "gp2"

  tags {
    Name = "Kubernetes etcd"
  }
}
