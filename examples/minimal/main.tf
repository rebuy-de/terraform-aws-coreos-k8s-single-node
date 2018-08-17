module "tacksn" {
  source = "github.com/rebuy-de/terraform-aws-coreos-k8s-single-node"
}

# Output IP, so we can connect via SSH to it
output "ip" {
  value = "${module.tacksn.ip}"
}

# Output Kubernetes config, so we can use kubectl
output "kubeconfig_admin" {
  value = "${module.tacksn.kubeconfig_admin}"
}
