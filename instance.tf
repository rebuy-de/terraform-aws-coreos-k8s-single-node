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

resource "aws_security_group" "main" {
  name = "Kubernetes"

  vpc_id = "${aws_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // apiserver HTTPS
  ingress {
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }

  // traefic HTTP
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  // traefic HTTPS
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "main" {
  key_name   = "example"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpTVTPl5/cbZxqOzMgEWIGJJhanOxyip7i78ptrLbzPXBT2hgm/ZisIpSZFw/a/gckEGWNCMI1F1GHzGU6Li+KFKJKEqANUO0uN3gDkSS/4Kmvf2+9IvDoAf8spCwpmWLs3U0naxOyaGR/b/sWaoNroIdyI8ycBV0B9Ml/v9CpFIFUop8EZIsxQLNonCRCzWjwYOe6V1ogxbDtyzsc0d1YTNSxrJNM0a0J+fmygOYoPK6zaBqDGW+EkorvL3Jhzq55Z9OzPggUwg46zNA/RkZXtcU0E+b1OlSPf2SuL2xlkAUynNV2AiRGtlXE1HLYaQUecB0G0AMu2tzhdoMZl+Pd root@903a617e4232"
}

resource "aws_instance" "main" {
  ami           = "${data.aws_ami.coreos.id}"
  instance_type = "t2.medium"

  associate_public_ip_address = true

  key_name = "${aws_key_pair.main.key_name}"

  user_data              = "${data.ignition_config.user_data.rendered}"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  subnet_id              = "${aws_subnet.public.id}"

  iam_instance_profile = "${aws_iam_instance_profile.node.id}"

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
