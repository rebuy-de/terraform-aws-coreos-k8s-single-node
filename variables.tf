variable "key_name" {
  type = "string"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "root_block_device_size" {
  default = "8"
}
