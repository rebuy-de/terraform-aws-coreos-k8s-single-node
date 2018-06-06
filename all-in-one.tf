terraform {
  required_version = "0.11.5"
}

provider "aws" {
  version = "1.11.0"
}

variable "ssh_key" {
  type = "string"
}

resource "aws_key_pair" "main" {
  key_name   = "kubernetes"
  public_key = "${var.ssh_key}"
}

module "base" {
  source = "base"
}

module "node" {
  source = "node"

  key_name = "${aws_key_pair.main.key_name}"

  instance_profile  = "${module.base.instance_profile}"
  subnet_id         = "${module.base.subnet_id}"
  security_group_id = "${module.base.security_group_id}"
}

output "ip" {
  value = "${module.node.ip}"
}

output "kubeconfig_admin" {
  value = "${module.node.kubeconfig_admin}"
}

output "instance" {
  value = "${module.node.instance}"
}
