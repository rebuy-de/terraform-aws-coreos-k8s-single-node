data "aws_caller_identity" "current" {}

terraform {
  required_version = "0.11.5"
}

provider "aws" {
  version = "1.11.0"
  profile = "default"
}
