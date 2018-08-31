# terraform-aws-coreos-k8s-single-node

[![License](https://img.shields.io/github/license/rebuy-de/terraform-aws-coreos-k8s-single-node.svg)]()

Single node Kubernetes cluster on CoreOS made with Terraform.

> **Development Status** *terraform-aws-coreos-k8s-single-node* is in an early development phase. Expect
> breaking changes any time.


## Use Cases

* It can be used as a very cheap Kubernetes cluster, which might be used for sandbox/staging environments.
* It can be used for non-critical workloads, which need AWS Account isolation.

## Usage

### Terraform

This project needs to be used as a Terraform module. See `examples/` directory for usage examples.

### Configure `kubectl`:

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

### Use add-ons:

#### DNS

One cluster add-on that you probably want to deploy is `kube-dns`, which makes it possible for your services to resolve external and internal hostnames.

```
kubectl apply -f
https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/deployments/kube-dns.yaml
```
