data "ignition_file" "apiserver_cert" {
  path       = "/etc/kubernetes/ssl/apiserver-cert.pem"
  mode       = 420
  filesystem = "root"

  content {
    content = tls_locally_signed_cert.apiserver.cert_pem
  }
}

data "ignition_file" "apiserver_key" {
  path       = "/etc/kubernetes/ssl/apiserver-key.pem"
  mode       = 420
  filesystem = "root"

  content {
    content = tls_private_key.apiserver.private_key_pem
  }
}

resource "tls_private_key" "apiserver" {
  algorithm = "RSA"
}

resource "tls_cert_request" "apiserver" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.apiserver.private_key_pem

  subject {
    common_name = "apiserver.default.svc.cluster.local"
  }

  dns_names = [
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "*.${data.aws_region.current.name}.compute.internal",
  ]

  ip_addresses = ["10.32.0.1"]
}

resource "tls_locally_signed_cert" "apiserver" {
  ca_key_algorithm   = tls_private_key.root.algorithm
  ca_private_key_pem = tls_private_key.root.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root.cert_pem

  cert_request_pem      = tls_cert_request.apiserver.cert_request_pem
  validity_period_hours = "87600"

  allowed_uses = [
    "any_extended",
    "cert_signing",
    "client_auth",
    "code_signing",
    "content_commitment",
    "data_encipherment",
    "decipher_only",
    "digital_signature",
    "email_protection",
    "encipher_only",
    "ipsec_end_system",
    "ipsec_tunnel",
    "ipsec_user",
    "key_agreement",
    "key_encipherment",
    "microsoft_server_gated_crypto",
    "netscape_server_gated_crypto",
    "ocsp_signing",
    "server_auth",
    "timestamping",
  ]
}

