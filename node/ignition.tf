locals {
  "ignition_files" = [
    "/etc/coreos/update.conf",
    "/etc/kubernetes/kubeconfig.yaml",
    "/etc/kubernetes/manifests/apiserver.yaml",
    "/etc/kubernetes/manifests/controller-manager.yaml",
    "/etc/kubernetes/manifests/proxy.yaml",
    "/etc/kubernetes/manifests/scheduler.yaml",
    "/etc/kubernetes/proxyconfig.yaml",
  ]
}

data "aws_caller_identity" "current" {}

data "ignition_config" "user_data" {
  append {
    source       = "s3://rebuy-single-node-ignition-${data.aws_caller_identity.current.account_id}/userdata.json"
    verification = "sha512-${sha512(data.ignition_config.s3.rendered)}"
  }
}

resource "aws_s3_bucket_object" "user_data" {
  bucket = "${aws_s3_bucket.user_data.id}"
  key    = "userdata.json"

  content = "${data.ignition_config.s3.rendered}"
  acl     = "private"

  server_side_encryption = "AES256"
}

resource "aws_s3_bucket" "user_data" {
  bucket = "rebuy-single-node-ignition-${data.aws_caller_identity.current.account_id}"
}

data "ignition_config" "s3" {
  files = ["${concat(
      data.ignition_file.files.*.id,
      list(data.ignition_file.auth_tokens.id),
      list(data.ignition_file.serviceaccount.id),
      list(
          data.ignition_file.root_ca.id,
          data.ignition_file.apiserver_cert.id,
          data.ignition_file.apiserver_key.id,
          data.ignition_file.kubelet_cert.id,
          data.ignition_file.kubelet_key.id,
      ),
  )}"]

  systemd = [
    "${data.ignition_systemd_unit.etcd.id}",
    "${data.ignition_systemd_unit.kubelet.id}",
    "${data.ignition_systemd_unit.etcd_mount.id}",
    "${data.ignition_systemd_unit.shared_mount.id}",
    "${data.ignition_systemd_unit.sethostname.id}",
  ]

  filesystems = [
    "${data.ignition_filesystem.etcd.id}",
    "${data.ignition_filesystem.shared.id}",
  ]
}

data "ignition_file" "files" {
  count = "${length(local.ignition_files)}"

  path       = "${local.ignition_files[count.index]}"
  mode       = 0644
  filesystem = "root"

  content {
    content = "${file("${path.module}/files${local.ignition_files[count.index]}")}"
  }
}

data "ignition_systemd_unit" "etcd" {
  name = "etcd-member.service"

  dropin {
    name    = "05-mount.conf"
    content = "${file("${path.module}/systemd/etcd-member.service.d/05-mount.conf")}"
  }
}

data "ignition_systemd_unit" "kubelet" {
  name    = "kubelet.service"
  content = "${file("${path.module}/systemd/kubelet.service")}"
}

data "ignition_systemd_unit" "etcd_mount" {
  name    = "var-lib-etcd.mount"
  content = "${file("${path.module}/systemd/var-lib-etcd.mount")}"
}

data "ignition_systemd_unit" "shared_mount" {
  name    = "mnt-shared.mount"
  content = "${file("${path.module}/systemd/mnt-shared.mount")}"
}

data "ignition_systemd_unit" "sethostname" {
  name    = "sethostname.service"
  content = "${file("${path.module}/systemd/sethostname.service")}"
}
