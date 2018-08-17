terraform {
  required_version = "0.11.5"

  # Configure to store the statefile in a S3 Bucket. The Bucket needs to exist.
  backend "s3" {
    profile = "my-kube"             # AWS profile name
    bucket  = "my-kube-statebucket"
    key     = "kubernetes.tfstate"
    region  = "eu-west-1"           # Bucket region
  }
}

provider "aws" {
  version             = "1.25.0"
  region              = "eu-west-1"
  profile             = "my-kube"     # AWS profile name
  allowed_account_ids = ["123457890"] # Limit account ID to prevent accidental execution on wrong account
}

# Set up SSH key for the EC2 instance
resource "aws_key_pair" "main" {
  key_name = "user"
  ssh_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDiXM5bj2uaiiPDmmi90v6cKwjfdVEjUo5khZVYGVn8ur1d8LGV1pKZ0w/WX2E9KhuI9V4UIlbZfZxk4WzkCEMMfa6Yum8x4ZGnmUGc5QLOhWkSpPi5k2rhcrviAOI6WYhzEhJV0Pna54xNcW3jUGR5Y2FvytNnsookEVMK6zm68Q== user@903a617e4232"
}

# Create the actual Kubernetes cluster
module "node" {
  source = "github.com/rebuy-de/terraform-aws-coreos-k8s-single-node/module"

  key_name               = "${aws_key_pair.main.key_name}"
  instance_type          = "t2.medium"
  root_block_device_size = "50"
}

# Add an additional Security Group rule to the EC2 instance
resource "aws_security_group_rule" "ingress_syncthing" {
  type              = "ingress"
  security_group_id = "${module.node.security_group_id}"

  protocol    = "tcp"
  from_port   = 22000
  to_port     = 22000
  cidr_blocks = ["0.0.0.0/0"]
}

# Output IP, so we can connect via SSH to it
output "ip" {
  value = "${module.tacksn.ip}"
}

# Output Kubernetes config, so we can use kubectl
output "kubeconfig_admin" {
  value = "${module.tacksn.kubeconfig_admin}"
}
