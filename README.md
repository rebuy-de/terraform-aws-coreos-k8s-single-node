# terraform-aws-coreos-k8s-single-node

Single node Kubernetes cluster on CoreOS made with Terraform.

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
