data "ignition_file" "auth_tokens" {
  path       = "/etc/kubernetes/tokens.csv"
  mode       = 420
  filesystem = "root"

  content {
    content = data.template_file.auth_tokens.rendered
  }
}

data "template_file" "auth_tokens" {
  template = file("${path.module}/templates/tokens.csv")

  vars = {
    cluster_admin = random_id.cluster_admin.b64
  }
}

resource "random_id" "cluster_admin" {
  byte_length = 128
}

