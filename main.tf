
provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION
}

/*
terraform {
  backend "s3" {
      encrypt = false
      bucket = "s3bucketvon2022"
      key = "deploy-stage/terraform_stage1.tfstate"
      region = "us-east-1"
      dynamodb_table = "terrform-stage2"
  }
}

*/