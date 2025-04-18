# The bucket is used to store images for processing with AWS Rekognition.

resource "aws_s3_bucket" "image_bucket" {
  bucket = "rekognition-image-upload-bucket1"  # Globally unique name
}