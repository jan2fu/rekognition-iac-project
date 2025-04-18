# This file contains the Terraform configuration for AWS Lambda and S3 bucket notifications.
# It sets up a Lambda function that processes images uploaded to an S3 bucket and stores results in DynamoDB.
# The Lambda function is triggered by S3 events, and it uses the AWS SDK to interact with Rekognition and DynamoDB.
# The code also includes IAM roles and policies to grant necessary permissions to the Lambda function.
# The code is structured to ensure security and least privilege access.
resource "aws_lambda_function" "rekognition_processor" {
  filename      = "../lambda/lambda.zip"
  function_name = "rekognition-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "rekognition_lambda.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.image_results.name
    }
  }
}

# Trigger Lambda when images are uploaded to S3
resource "aws_s3_bucket_notification" "image_upload_trigger" {
  bucket = aws_s3_bucket.image_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.rekognition_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# Allow S3 to invoke Lambda
resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rekognition_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.image_bucket.arn
}