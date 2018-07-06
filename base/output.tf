output "instance_profile" {
  value = "${aws_iam_instance_profile.node.id}"
}

output "subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "security_group_id" {
  value = "${aws_security_group.main.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
