terraform {
  backend "s3" {
    bucket         = "apc-tfstate-aws-0001"
    key            = "terraform/tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table-01"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}
