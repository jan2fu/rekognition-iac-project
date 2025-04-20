# store Terraform state remotely in S3.

terraform {
  backend "s3" {
    bucket = "rekognition-tf-state"  
    key    = "rekognition-pipeline/terraform.tfstate"
    region = "us-east-1"
  }
}

