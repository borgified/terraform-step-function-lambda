terraform {
  required_version = "0.12.1"
  backend "remote" {
    organization = "terraform-testing"

    workspaces {
      name = "hackweek"
    }
  }
}
