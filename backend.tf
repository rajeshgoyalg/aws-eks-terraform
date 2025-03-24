terraform {
  backend "s3" {
    bucket         = "tf-state-demo-app"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tf-locking-demo-app"
    encrypt        = true
  }
}