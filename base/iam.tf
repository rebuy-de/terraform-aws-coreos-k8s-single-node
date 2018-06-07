resource "aws_iam_instance_profile" "node" {
  name = "kubernetes-node"
  role = "${aws_iam_role.node.name}"
}

resource "aws_iam_role" "node" {
  name               = "kubernetes-node"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "assume_role" {
  # Every node can take this identity, that is not changeable.
  statement {
    "principals" {
      "type" = "Service"

      "identifiers" = [
        "ec2.amazonaws.com",
      ]
    }

    "actions" = [
      "sts:AssumeRole",
    ]

    "effect" = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "node_cloud_provider" {
  role       = "${aws_iam_role.node.name}"
  policy_arn = "${aws_iam_policy.cloud_provider.arn}"
}

resource "aws_iam_policy" "cloud_provider" {
  name   = "kubernetes-cloud-provider"
  policy = "${data.aws_iam_policy_document.cloud_provider.json}"
}

data "aws_iam_policy_document" "cloud_provider" {
  statement {
    "effect" = "Allow"

    "actions" = [
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "elasticloadbalancing:DescribeLoadBalancers",
      "ec2:AttachVolume",
      "ec2:CreateVolume",
      "ec2:DeleteVolume",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:DescibeVolumeAttribute",
      "ec2:CreateTags",
      "ec2:DescribeTags",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
    ]

    "resources" = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ignition_access" {
  role       = "${aws_iam_role.node.name}"
  policy_arn = "${aws_iam_policy.ignition_access.arn}"
}

resource "aws_iam_policy" "ignition_access" {
  name   = "kubernetes-ignition-access"
  policy = "${data.aws_iam_policy_document.ignition_access.json}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ignition_access" {
  statement {
    "effect" = "Allow"

    "actions" = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    "resources" = [
      "arn:aws:s3:::rebuy-terraform-state-${data.aws_caller_identity.current.account_id}/*",
    ]
  }

  statement {
    "effect" = "Allow"

    "actions" = [
      "s3:ListBucket",
    ]

    "resources" = [
      "*",
    ]
  }
}
