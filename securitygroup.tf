resource "aws_security_group" "main" {
  name   = "Kubernetes"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.main.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.main.id

  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_apiserver" {
  type              = "ingress"
  security_group_id = aws_security_group.main.id

  protocol    = "tcp"
  from_port   = 6443
  to_port     = 6443
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  security_group_id = aws_security_group.main.id

  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_https" {
  type              = "ingress"
  security_group_id = aws_security_group.main.id

  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
}

