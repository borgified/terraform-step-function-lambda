terraform {
  required_version = "0.12.9"
  backend "remote" {
    organization = "terraform-testing"

    workspaces {
      name = "hackweek"
    }
  }
}
