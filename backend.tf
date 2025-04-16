terraform {
  backend "s3" {
    bucket         = "tf-state-demo-app-rgoyal"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tf-locking-demo-app-rgoyal"
    encrypt        = true
  }
}