locals {
  ignition_files = [
    "/etc/coreos/update.conf",
    "/etc/kubernetes/kubeconfig.yaml",
    "/etc/kubernetes/manifests/apiserver.yaml",
    "/etc/kubernetes/manifests/controller-manager.yaml",
    "/etc/kubernetes/manifests/proxy.yaml",
    "/etc/kubernetes/manifests/scheduler.yaml",
    "/etc/kubernetes/proxyconfig.yaml",
  ]
}

data "ignition_config" "user_data" {
  append {
    source       = "s3://rebuy-single-node-ignition-${data.aws_caller_identity.current.account_id}/userdata.json"
    verification = "sha512-${sha512(data.ignition_config.s3.rendered)}"
  }
}

resource "aws_s3_bucket_object" "user_data" {
  bucket = aws_s3_bucket.user_data.id
  key    = "userdata.json"

  content = data.ignition_config.s3.rendered
  acl     = "private"

  server_side_encryption = "AES256"
}

resource "aws_s3_bucket" "user_data" {
  bucket = "rebuy-single-node-ignition-${data.aws_caller_identity.current.account_id}"
}

data "ignition_config" "s3" {
  files = concat(
    data.ignition_file.files.*.rendered,
    [data.ignition_file.auth_tokens.rendered],
    [data.ignition_file.serviceaccount.rendered],
    [
      data.ignition_file.root_ca.rendered,
      data.ignition_file.apiserver_cert.rendered,
      data.ignition_file.apiserver_key.rendered,
      data.ignition_file.kubelet_cert.rendered,
      data.ignition_file.kubelet_key.rendered,
    ],
  )

  systemd = [
    data.ignition_systemd_unit.etcd.rendered,
    data.ignition_systemd_unit.kubelet.rendered,
    data.ignition_systemd_unit.etcd_mount.rendered,
    data.ignition_systemd_unit.shared_mount.rendered,
    data.ignition_systemd_unit.sethostname.rendered,
  ]

  filesystems = [
    data.ignition_filesystem.etcd.rendered,
    data.ignition_filesystem.shared.rendered,
  ]

  users = [
    data.ignition_user.default.rendered,
  ]
}

data "ignition_user" "default" {
  name                = "core"
  ssh_authorized_keys = var.keys
}

data "ignition_file" "files" {
  count = length(local.ignition_files)

  path       = local.ignition_files[count.index]
  mode       = 420
  filesystem = "root"

  content {
    content = file("${path.module}/files${local.ignition_files[count.index]}")
  }
}

data "ignition_systemd_unit" "etcd" {
  name = "etcd-member.service"

  dropin {
    name    = "05-mount.conf"
    content = file("${path.module}/systemd/etcd-member.service.d/05-mount.conf")
  }
}

data "ignition_systemd_unit" "kubelet" {
  name    = "kubelet.service"
  content = file("${path.module}/systemd/kubelet.service")
}

data "ignition_systemd_unit" "etcd_mount" {
  name    = "var-lib-etcd.mount"
  content = file("${path.module}/systemd/var-lib-etcd.mount")
}

data "ignition_systemd_unit" "shared_mount" {
  name    = "mnt-shared.mount"
  content = file("${path.module}/systemd/mnt-shared.mount")
}

data "ignition_systemd_unit" "sethostname" {
  name    = "sethostname.service"
  content = file("${path.module}/systemd/sethostname.service")
}
