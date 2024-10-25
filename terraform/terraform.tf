terraform {
  backend "s3" {
    bucket         = "<your_s3_bucket>"
    key            = "terraform/tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "<your_dynamodb_table>"
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
