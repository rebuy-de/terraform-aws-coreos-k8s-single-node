data "aws_ami" "coreos" {
  owners      = ["595879546273"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "main" {
  ami                         = "${data.aws_ami.coreos.id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"
  user_data                   = "${data.ignition_config.user_data.rendered}"
  subnet_id                   = "${aws_subnet.public.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.node.id}"

  root_block_device {
    volume_size = "${var.root_block_device_size}"
  }

  vpc_security_group_ids = ["${aws_security_group.main.id}"]

  tags {
    Name                         = "Kubernetes"
    "kubernetes.io/cluster/blub" = "owned"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }
}

resource "aws_eip" "main" {
  instance = "${aws_instance.main.id}"
  vpc      = true

  tags {
    Name = "Kubernetes"
  }
}
