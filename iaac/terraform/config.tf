terraform {
  backend "s3" {
    bucket         = "remotestateawslevi9interndevops"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "app-state"
    encrypt        = true
    shared_credentials_files = ["~/.aws/credentials"]
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.45"
    }
  }
}
