# This file contains the IAM roles and policies for AWS Lambda and GitHub Actions.
# It sets up the necessary permissions for Lambda to access AWS Rekognition and DynamoDB,
# and for GitHub Actions to access S3 for deployment purposes.

# Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-rekognition-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Role for GitHub Actions (OIDC)
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity",
      Effect = "Allow",
      Principal = { 
        Federated = "arn:aws:iam::515966535961:oidc-provider/token.actions.githubusercontent.com"
      }, # GitHub OIDC provider 
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:https://github.com/jan2fu/rekognition-iac-project:*"
        }
      }
    }]
  })
}

# Lambda permissions
resource "aws_iam_role_policy_attachment" "lambda_rekognition" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# GitHub Actions permissions
resource "aws_iam_role_policy_attachment" "github_actions_s3" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}