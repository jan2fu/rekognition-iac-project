# This file contains the Terraform configuration for creating a DynamoDB table.
# It sets up a table to store image processing results from AWS Rekognition.

resource "aws_dynamodb_table" "image_results" {
  name         = "ImageResults"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "image_name"

  attribute {
    name = "image_name"
    type = "S"
  }
}