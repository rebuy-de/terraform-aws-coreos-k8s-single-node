variable "key_name" {
  description = "Name of the AWS Key Pair, that is used for the EC2 instance. Can be created with `aws_key_pair`"
  type        = "string"
}

variable "instance_type" {
  description = "Size of the EC2 instance."
  default     = "t2.micro"
}

variable "root_block_device_size" {
  description = "Size of the root volume of the EC2 instance."
  default     = "8"
}
