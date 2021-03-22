terraform {
  required_version = ">= 0.12"
}
# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "githublearn-tf-state"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "githublearn-tf-state-locks"
    encrypt        = true
  }
}