provider "aws" {
}

terraform {
  backend "s3" {
    bucket = "tf-states-ephemeral-env"
    key = "tf-states/ephemeral-env.tfstate"
    region = "eu-west-1"
  }
}
