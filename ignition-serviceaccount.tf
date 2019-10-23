resource "tls_private_key" "serviceaccount" {
  algorithm = "RSA"
}

data "ignition_file" "serviceaccount" {
  path       = "/etc/kubernetes/serviceaccount.pem"
  mode       = 420
  filesystem = "root"

  content {
    content = tls_private_key.serviceaccount.private_key_pem
  }
}

