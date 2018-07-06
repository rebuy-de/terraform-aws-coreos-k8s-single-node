variable "instance_profile" {
  type = "string"
}

variable "subnet_id" {
  type = "string"
}

variable "security_group_id" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "additional_security_group_id" {
  default = ""
}
