terraform {
  backend "s3" {
    bucket         = "galter-terraform-state-bucket"
    key            = "bootstrap/bootstrap-terraform.tfstate"
    region         = "il-central-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}