output "ip" {
  description = "IP address for the EC2 instance. Connect via SSH with `ssh core@<IP>`"
  value       = aws_eip.main.public_ip
}

data "template_file" "kubeconfig_remote" {
  template = file("${path.module}/templates/kubeconfig-remote.yaml")

  vars = {
    apiserver = aws_eip.main.public_ip
    token     = random_id.cluster_admin.b64
  }
}

output "kubeconfig_admin" {
  description = "Kubernetes config for the cluster administrator. Extract it with `terraform output kubeconfig_admin > ~/.kube/config-single-node`"
  value       = data.template_file.kubeconfig_remote.rendered
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "vpc_id" {
  description = "ID of the VPC Network"
  value       = aws_vpc.main.id
}

output "security_group_id" {
  description = "ID of the Security Group of the EC2 instance. Add additional rules with `aws_security_group_rule`"
  value       = aws_security_group.main.id
}

