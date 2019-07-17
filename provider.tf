
provider "aws" {
  region = "${var.region}"
  version = "~> 2.19"
}

provider "archive" {
  version = "~> 1.2"
}
