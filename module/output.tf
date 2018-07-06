output "ip" {
  value = "${aws_eip.main.public_ip}"
}

data "template_file" "kubeconfig_remote" {
  template = "${file("${path.module}/templates/kubeconfig-remote.yaml")}"

  vars {
    apiserver = "${aws_eip.main.public_ip}"
    token     = "${random_id.cluster_admin.b64}"
  }
}

output "kubeconfig_admin" {
  value = "${data.template_file.kubeconfig_remote.rendered}"
}

output "instance" {
  value = "${aws_instance.main.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
