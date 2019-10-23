variable "keys" {
  description = "List of authorized ssh public keys."
  type        = list(string)
}

variable "instance_type" {
  description = "Size of the EC2 instance."
  default     = "t2.micro"
}

variable "root_block_device_size" {
  description = "Size of the root volume of the EC2 instance."
  default     = "8"
}

