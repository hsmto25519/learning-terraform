# Specify the AWS provider
provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket  = "apc-tfstate-aws-0001"
    key     = "terraform/tfstate"
    region  = "ap-northeast-1"
    encrypt = true
    # dynamodb_table = "your-lock-table"
  }
}
