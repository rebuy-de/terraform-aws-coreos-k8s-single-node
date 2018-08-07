variable "key_name" {
  type = "string"
}

variable "additional_security_group_ids" {
  default = []
}

variable "instance_type" {
  default = "t2.micro"
}

variable "root_block_device_size" {
  default = "8"
}
