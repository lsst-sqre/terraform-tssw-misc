provider "aws" {
  version = "~> 1.60"
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

provider "template" {
  version = "~> 2.1"
}
