# terraform-aws-coreos-k8s-single-node

Single node Kubernetes cluster on CoreOS made with Terraform.

## Usage

This project needs to be used as a Terraform module:

```hcl
terraform {
  profile = "default"
}

module "tacksn" {
  source = "github.com/rebuy-de/terraform-aws-coreos-k8s-single-node"

  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDiXM5bj2uaiiPDmmi90v6cKwjfdVEjUo5khZVYGVn8ur1d8LGV1pKZ0w/WX2E9KhuI9V4UIlbZfZxk4WzkCEMMfa6Yum8x4ZGnmUGc5QLOhWkSpPi5k2rhcrviAOI6WYhzEhJV0Pna54xNcW3jUGR5Y2FvytNnsookEVMK6zm68Q== user@903a617e4232"
}

output "ip" {
  value = "${module.tacksn.ip}"
}

output "kubeconfig_admin" {
  value = "${module.tacksn.kubeconfig_admin}"
}

output "instance" {
  value = "${module.tacksn.instance}"
}
```

## Configure `kubectl`:

Output the kube-config file from terraform into local file:
```
terraform output kubeconfig_admin > ~/.kube/config-single-node
```

Configure `kubectl` to use this file:
```
export KUBECONFIG=~/.kube/config-single-node
```

Test if it works:
```
kubectl get pods --all-namespaces
```

## Use add-ons:

### DNS

One cluster add-on that you probably want to deploy is `kube-dns`, which makes it possible for your services to resolve external and internal hostnames.

```
kubectl apply -f
https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/deployments/kube-dns.yaml
```
