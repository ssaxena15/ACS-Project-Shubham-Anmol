provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state_s3" {
    bucket = "project-web2tier-tf-state-storage"
    
    force_destroy = true

    #versioning {
    #    enabled = false
    #}

    tags = {
        name = "Terraform State Store"
    }
}

resource "aws_dynamodb_table" "tf_locks" {
# Give unique name for dynamo table name
    name  = "tf-locks"
    hash_key = "LockID"
    read_capacity = 20
    write_capacity = 20
    attribute {
        name = "LockID"
        type = "S"
  }
  tags = {
      name = "DynamoDB TF State Lock Table"
  }
}

