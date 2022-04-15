terraform {
  backend "s3" {
    encrypt = true
    # cannot contain interpolations
    bucket = "project-web2tier-tf-state-storage"
    
    region = "us-east-1"
    dynamodb_table = "tf-locks"
    key = "tf/s3/terraform.tfstate"
  }
}