provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project = "SQS + lambda demo"
      Repo    = "sqsdemo"
    }
  }
}

terraform {
  backend "s3" {
    key            = "sqsdemo.tfstate"
    dynamodb_table = "terraform-lock-sqsdemo"
    region         = "eu-west-1"
  }
}