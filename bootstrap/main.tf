resource "aws_s3_bucket" "terraform_state" {
  bucket = "galter-terraform-state-bucket"

  tags = {
    Name        = "Terraform State"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"  
  hash_key       = "LockID"           

  attribute {
    name = "LockID"                 
    type = "S"                       
  }

  tags = {
    Name        = "Terraform Lock"
    Environment = "Production"
  }
}
